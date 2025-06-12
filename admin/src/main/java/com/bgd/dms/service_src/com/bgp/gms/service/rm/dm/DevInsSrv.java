package com.bgp.gms.service.rm.dm;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.jsoup.helper.StringUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.bgp.dms.util.CommonConstants;
import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.bgp.mcs.service.common.excelIE.util.ExcelExceptionHandler;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.mat.util.ExcelEIResolvingUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;
import com.runqian.report.engine.function.math.Int;

/**
 * project: ������̽��Ŀ����ϵͳ
 * 
 * @author dushuai * description:�豸ģ����ز鿴��ά������
 * 
 */
@Service("DevInsSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevInsSrv extends BaseService {

	public DevInsSrv() {
		log = LogFactory.getLogger(DevInsSrv.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	public ISrvMsg getGZLInfo (ISrvMsg isrvmsg) throws Exception {
		log.info("getGZLInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String procinst_id=isrvmsg.getValue("apply_id");//׼������豸�������б�
		 
		String sql="";
		 List<Map> list=jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	} 
	/**
	 * ��Ŀά�����ĶԱ� ��̽��
	 * 
	 * @return dateSets
	 */
	public ISrvMsg getDevReoaProjectsWUTAN(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String sub_id=user.getSubOrgIDofAffordOrg();
	 
		String startDate=reqDTO.getValue("startDate");//��ʼʱ��
	 
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "1";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
	  
		StringBuilder sql = new StringBuilder();
		sql.append("select * from(select nvl(sum(pinfo.material_cost+pinfo.human_cost),0) totalcost,t1.project_name,t1.project_info_no from BGP_COMM_DEVICE_REPAIR_INFO pinfo inner join (select t.* from (select p.project_name, p.project_info_no, p.project_type, p.PROJECT_STATUS, nvl(p.project_year, to_char(nvl(p.project_start_time, p.acquire_start_time), 'yyyy')) as pro_year from gp_task_project p left join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method where 1 = 1 and p.bsflag = '0' and dy.org_subjection_id like '"+sub_id+"%') t where 1 = 1 and t.project_type in ('5000100004000000001', '5000100004000000002', '5000100004000000010', '5000100004000000007')  and pro_year = '"+startDate+"' order by pro_year desc, nvl(length(trim(t.project_name)), 0)) t1 on t1.project_info_no=pinfo.project_info_no  and pinfo.repair_level='603'  group by t1.project_name,t1.project_info_no) where totalcost>0");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "ά�޽�� : ��Ԫ");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		root.addAttribute("staggerLines", "3");
		root.addAttribute("caption", "");
		Element categories = root.addElement("categories");
		Element[] categorys = new Element[list.size()];
		double uncount = 0;
		double count = 0;
	 
		// ��������
		if (CollectionUtils.isNotEmpty(list)) {
			for (int index = 0; index < list.size(); index++) {
				Map map = (Map) list.get(index);
				
				Element set = root.addElement("set");
				categorys[index] = categories.addElement("category");
				
				categorys[index].addAttribute("width", "24");
				categories.addAttribute("fontSize", "12");
			 
				double  money=Double.parseDouble((String)map.get("totalcost"))/10000;
				set.addAttribute("value", String.valueOf(money));
				set.addAttribute("label", (String)map.get("project_name"));//���
				set.addAttribute("link",  "JavaScript:popDevList('"+(String)map.get("project_info_no")+"')");
				
			 
			}
		}
		 
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * ��Ŀά�����ĶԱ� ��������Ա
	 * 
	 * @return dateSets
	 */
	public ISrvMsg getDevReoaProjects(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String sub_id=user.getSubOrgIDofAffordOrg();
	 
		String startDate=reqDTO.getValue("startDate");//��ʼʱ��
	 
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "1";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
	  
		StringBuilder sql = new StringBuilder();
		sql.append("select * from(select nvl(sum(pinfo.material_cost + pinfo.human_cost), 0) totalcost, t1.project_name, t1.project_info_no from BGP_COMM_DEVICE_REPAIR_INFO pinfo inner join gms_device_account_dui dui on dui.dev_acc_id=pinfo.device_account_id inner join dms_device_tree dt on dt.device_code =dui.dev_type and dt.bsflag='0' and dt.device_code is not null and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%') inner join (select t.* from (select p.project_name, p.project_info_no, p.project_type, p.PROJECT_STATUS, nvl(p.project_year, to_char(nvl(p.project_start_time, p.acquire_start_time), 'yyyy')) as pro_year from gp_task_project p left join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method where 1 = 1 and p.bsflag = '0' and dy.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%') t where 1 = 1 and t.project_type in ('5000100004000000001', '5000100004000000002', '5000100004000000010', '5000100004000000007') and t.project_status = '5000100001000000002' and pro_year = '"+startDate+"' order by pro_year desc, nvl(length(trim(t.project_name)), 0)) t1 on t1.project_info_no = pinfo.project_info_no and pinfo.repair_level = '603' group by t1.project_name, t1.project_info_no) where totalcost > 0 ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "ά�޽�� : ��Ԫ");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		root.addAttribute("staggerLines", "3");
		root.addAttribute("caption", "");
		Element categories = root.addElement("categories");
		Element[] categorys = new Element[list.size()];
		double uncount = 0;
		double count = 0;
		Element nx = root.addElement("dataset");
		nx.addAttribute("seriesName", "��Ŀά��");//��Ŀ����
		nx.addAttribute("color", "ec4224");
		// ��������
		if (CollectionUtils.isNotEmpty(list)) {
			for (int index = 0; index < list.size(); index++) {
				Map map = (Map) list.get(index);
				
				Element set = root.addElement("set");
				categorys[index] = categories.addElement("category");
				categorys[index].addAttribute("label", (String)map.get("project_name"));//���
				categorys[index].addAttribute("width", "24");
				categories.addAttribute("fontSize", "12");
				Element setcjz = nx.addElement("set");//
				double  money=Double.parseDouble((String)map.get("totalcost"))/10000;
				setcjz.addAttribute("value", String.valueOf(money));
				setcjz.addAttribute("link",  "JavaScript:popDevList('"+(String)map.get("project_info_no")+"')");
			 
			}
		}
		 
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	//�����ɫ16����
		public  String getRandColorCode(){  
			  String r,g,b;  
			  Random random = new Random();  
			  r = Integer.toHexString(random.nextInt(256)).toUpperCase();  
			  g = Integer.toHexString(random.nextInt(256)).toUpperCase();  
			  b = Integer.toHexString(random.nextInt(256)).toUpperCase();  
			     
			  r = r.length()==1 ? "0" + r : r ;  
			  g = g.length()==1 ? "0" + g : g ;  
			  b = b.length()==1 ? "0" + b : b ;  
			     
			  return r+g+b;  
		}
	/**
	 * ���װ����Դ��,�����ͼ����ʾ
	 * 
	 * @return dateSets
	 */
	public ISrvMsg getDevReoaOrgsWUTAN(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String sub_id=user.getSubOrgIDofAffordOrg();
		String dev_type=reqDTO.getValue("dev_type");//�豸����
		String startDate=reqDTO.getValue("startDate");//��ʼʱ��
		String endDate=reqDTO.getValue("endDate");//����ʱ��
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "1";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
		String vcountry = "";
		if (StringUtils.isBlank(country)) {
			country = "";
		} else {
			if ("1".equals(country)) {
				vcountry = "����";
			}
			if ("2".equals(country)) {
				vcountry = "����";
			}
		}

		StringBuilder sql = new StringBuilder();
		sql.append("select wm_concat(num) num,wm_concat(repairtype) repairtype,devname from( select num,'��Ŀά��' repairtype, devname from ( select count(*) num ,DeviceTreeIdToName(dt.dev_tree_id) devname from BGP_COMM_DEVICE_REPAIR_INFO pinfo left join gms_device_account_dui dui on dui.dev_acc_id = pinfo.device_account_id left join dms_device_tree dt on dt.device_code=dui.dev_type inner join (select t.project_info_no,org_id from (select p.project_info_no, p.project_name as t_project_name, p.project_type, dy.org_id from gp_task_project p left join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method where 1 = 1 and p.bsflag = '0' and dy.org_subjection_id like '"+sub_id+"%') t where 1 = 1 and t.project_type in ('5000100004000000001', '5000100004000000002', '5000100004000000010', '5000100004000000007')) t1 on t1.project_info_no =pinfo.project_info_no left join comm_org_subjection orginfo on orginfo.org_id=t1.org_id where pinfo.bsflag='0' " );
		
		sql.append(" and  pinfo.REPAIR_START_DATE between to_date('"+startDate+"','yyyy-MM-dd') and to_date('"+endDate+"','yyyy-MM-dd')  and pinfo.project_info_no is not null and dt.bsflag = '0' and dt.device_code is not null " );
		if(StringUtils.isNotBlank(dev_type)){
			sql.append(" and (dt.dev_tree_id like '"+dev_type+"%' ) ");
		}else{
			sql.append(" and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%') ");
		}
		sql.append(" group by DeviceTreeIdToName(dt.dev_tree_id)) union all select count(*) num ,repairtype, devname from ( select (select coding_name from comm_coding_sort_detail where coding_code_id = info.repair_type) as repairtype, DeviceTreeIdToName(dt.dev_tree_id) devname from bgp_comm_device_repair_info info inner join gms_device_account account on account.dev_acc_id = info.device_account_id and account.bsflag = '0' left join dms_device_tree dt on dt.device_code= account.dev_type left join comm_org_information orginfo on orginfo.org_id=account.owning_org_id left join comm_org_subjection subinfo on orginfo.org_id=subinfo.org_id where info.bsflag = '0' and  info.REPAIR_START_DATE between to_date('"+startDate+"','yyyy-MM-dd') and to_date('"+endDate+"','yyyy-MM-dd') and info.repair_level <> '605' and (info.datafrom <> 'SAP' or info.datafrom is null) and account.owning_sub_id like '"+sub_id+"%' and account.account_stat in ('0110000013000000003', '0110000013000000001', '0110000013000000006') and dt.bsflag = '0' and dt.device_code is not null " );
		if(StringUtils.isNotBlank(dev_type)){
			sql.append(" and (dt.dev_tree_id like '"+dev_type+"%' ) ");
		}else{
			sql.append(" and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%') ");
		}
		sql.append(" order by info.repair_start_date desc ) group by repairtype,devname )group by devname");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "ά�޴���");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		root.addAttribute("staggerLines", "3");
		root.addAttribute("caption", "");

		Element categories = root.addElement("categories");
		Element[] categorys = new Element[list.size()];
		
		Element nx = root.addElement("dataset");
		nx.addAttribute("seriesName", "����");
		nx.addAttribute("color", "45b3ec");
		
		Element wx = root.addElement("dataset");
		wx.addAttribute("seriesName", "����");
		wx.addAttribute("color", "ec4224");
		Element xmwx = root.addElement("dataset");
		xmwx.addAttribute("seriesName", "��Ŀά��");
		xmwx.addAttribute("color", "ffd200");
		int cLevel = Integer.parseInt(level);// ��ǰ��ȡ����
		int nLevel = cLevel + 1;// ��һ��ȡ����
		double uncount = 0;
		double count = 0;
		// ��������
		if (CollectionUtils.isNotEmpty(list)) {
			for (int index = 0; index < list.size(); index++) {
				Map map = (Map) list.get(index);
				Map<String,String> nums=new HashMap<String, String>();
				nums.put("����", "0");
				nums.put("����", "0");
				nums.put("��Ŀά��", "0");
				
				Element set = root.addElement("set");
				 
				categorys[index] = categories.addElement("category");
				String [] totalnum=((String)map.get("num")).split(",");
				String [] repairtype=((String)map.get("repairtype")).split(",");
				for (int i=0;i<totalnum.length;i++) {
					nums.put(repairtype[i], totalnum[i]);
				}
				//categorys[index].addAttribute("label", (String)dataMap.get("projectName"));
				categorys[index].addAttribute("label", (String)map.get("devname"));//���
				categorys[index].addAttribute("width", "24");
				categories.addAttribute("fontSize", "12");
				
			 
				Element setcjz = nx.addElement("set");//����
				setcjz.addAttribute("link",  "JavaScript:popDevList('����','"+(String)map.get("devname")+"')");
				setcjz.addAttribute("value", nums.get("����"));
				//setcjz.addAttribute("toolText","���� "+totals[0]+"̨,����"+unuse_nums[0]+"̨ ");
				
				Element setjcz = wx.addElement("set");//����
				setjcz.addAttribute("link",  "JavaScript:popDevList('����','"+(String)map.get("devname")+"')");
				setjcz.addAttribute("value",nums.get("����"));
				//setjcz.addAttribute("toolText","���� "+totals[1]+"̨,����"+unuse_nums[1]+"̨ ");
				
				Element setdyz = xmwx.addElement("set");//��Ŀά��
				setdyz.addAttribute("link",  "JavaScript:popDevList('��Ŀά��','"+(String)map.get("devname")+"')");
				setdyz.addAttribute("value", nums.get("��Ŀά��"));
				//setdyz.addAttribute("toolText","���� "+totals[2]+"̨,����"+unuse_nums[2]+"̨ ");

			}
		}
		double tempresult = 0;
		if (count >= 0) {
			tempresult = uncount / count;
		}
		 
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * �豸��Ŀ�ֲ�
	 * 
	 * @return dateSets
	 */
	public ISrvMsg getDevOnProjectInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String sub_id=user.getSubOrgIDofAffordOrg();
		String dev_type=reqDTO.getValue("dev_type");//�豸����
		String startDate=reqDTO.getValue("startDate");//��ʼʱ��
		String endDate=reqDTO.getValue("endDate");//����ʱ��
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "1";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
		String vcountry = "";
		if (StringUtils.isBlank(country)) {
			country = "";
		} else {
			if ("1".equals(country)) {
				vcountry = "����";
			}
			if ("2".equals(country)) {
				vcountry = "����";
			}
		}

		StringBuilder sql = new StringBuilder();
		 sql.append("select wm_concat(sum) sum, wm_concat(type) type, t_project_name,project_info_no from(select sum(a) sum, to_char(b) type, t_project_name,project_info_no from (select t1.t_project_name,t1.project_info_no, count(substr(dev_tree_id, 0, 4)) a, substr(dev_tree_id, 0, 4) b from gms_device_account_dui dui inner join dms_device_tree dt on dt.device_code = dui.dev_type inner join (select t.project_info_no, org_id, t_project_name from (select p.project_info_no, p.project_name as t_project_name, p.project_type, dy.org_id from gp_task_project p left join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method where 1 = 1 and p.bsflag = '0' and dy.org_subjection_id like '"+sub_id+"%' and p.PROJECT_YEAR = '"+startDate+"') t where 1 = 1 and t.project_type in ('5000100004000000001', '5000100004000000002', '5000100004000000010', '5000100004000000007')) t1 on t1.project_info_no = dui.project_info_id where dt.bsflag = '0' and dt.device_code is not null and (dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D005%' or dt.dev_tree_id like 'D006%') group by t_project_name,project_info_no, substr(dev_tree_id, 0, 4)) group by t_project_name, b,project_info_no) group by t_project_name ,project_info_no ");
		 List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "����");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		root.addAttribute("staggerLines", "3");
		root.addAttribute("caption", "");

		Element categories = root.addElement("categories");
		Element[] categorys = new Element[list.size()];
		
		Element wtzj = root.addElement("dataset");
		wtzj.addAttribute("seriesName", "��̽���");
		wtzj.addAttribute("color", "45b3ec");
		
		Element yssb = root.addElement("dataset");
		yssb.addAttribute("seriesName", "�����豸");
		yssb.addAttribute("color", "ec4224");
		Element jbq = root.addElement("dataset");
		jbq.addAttribute("seriesName", "�첨��");
		jbq.addAttribute("color", "ffd200");
		Element ttj = root.addElement("dataset");
		ttj.addAttribute("seriesName", "������");
		ttj.addAttribute("color", "C0FF3E");
		int cLevel = Integer.parseInt(level);// ��ǰ��ȡ����
		int nLevel = cLevel + 1;// ��һ��ȡ����
		double uncount = 0;
		double count = 0;
		// ��������
		if (CollectionUtils.isNotEmpty(list)) {
			for (int index = 0; index < list.size(); index++) {
				Map map = (Map) list.get(index);
				Map<String,String> nums=new HashMap<String, String>();
				nums.put("D003", "0");
				nums.put("D004", "0");
				nums.put("D005", "0");
				nums.put("D006", "0");
				Element set = root.addElement("set");
				 
				categorys[index] = categories.addElement("category");
				String [] totalnum=((String)map.get("sum")).split(",");
				String [] repairtype=((String)map.get("type")).split(",");
				for (int i=0;i<totalnum.length;i++) {
					nums.put(repairtype[i], totalnum[i]);
				}
				//categorys[index].addAttribute("label", (String)dataMap.get("projectName"));
				categorys[index].addAttribute("label", (String)map.get("t_project_name"));//���
				categorys[index].addAttribute("width", "24");
				categories.addAttribute("fontSize", "12");
				
				 
				Element setcjz = wtzj.addElement("set");//D003
				setcjz.addAttribute("link",  "JavaScript:popDevList('D003','"+(String)map.get("project_info_no")+"')");
				setcjz.addAttribute("value", nums.get("D003"));
				 
				
				 
				Element setjcz = yssb.addElement("set");//D004
				setjcz.addAttribute("link",  "JavaScript:popDevList('D004','"+(String)map.get("project_info_no")+"')");
				setjcz.addAttribute("value",nums.get("D004"));
				 
				
				 
				Element setdyz = jbq.addElement("set");//D005
				setdyz.addAttribute("link",  "JavaScript:popDevList('D005','"+(String)map.get("project_info_no")+"')");
				setdyz.addAttribute("value", nums.get("D005"));
				 
				
				 
				Element setdyz1 = ttj.addElement("set");//D006
				setdyz1.addAttribute("link",  "JavaScript:popDevList('D006','"+(String)map.get("project_info_no")+"')");
				setdyz1.addAttribute("value", nums.get("D006"));
				 

			}
		}
		double tempresult = 0;
		if (count >= 0) {
			tempresult = uncount / count;
		}
		 
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * ���װ����Դ��,�����ͼ����ʾ
	 * 
	 * @return dateSets
	 */
	public ISrvMsg getDevReoaOrgs(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String dev_type=reqDTO.getValue("dev_type");//�豸����
		String startDate=reqDTO.getValue("startDate");//��ʼʱ��
		String endDate=reqDTO.getValue("endDate");//����ʱ��
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "1";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
		String vcountry = "";
		if (StringUtils.isBlank(country)) {
			country = "";
		} else {
			if ("1".equals(country)) {
				vcountry = "����";
			}
			if ("2".equals(country)) {
				vcountry = "����";
			}
		}

		StringBuilder sql = new StringBuilder();
		sql.append("select wm_concat(num) num,wm_concat(repairtype) repairtype,orgname from(select num,'��Ŀά��' repairtype,orgname from ( select count(*) num ,OrgSubIdToName(orginfo.org_subjection_id) orgname from BGP_COMM_DEVICE_REPAIR_INFO pinfo left join gms_device_account_dui dui on dui.dev_acc_id = pinfo.device_account_id left join dms_device_tree dt on dt.device_code=dui.dev_type inner join (select t.project_info_no,org_id from (select p.project_info_no, p.project_name as t_project_name, p.project_type, dy.org_id from gp_task_project p left join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method where 1 = 1 and p.bsflag = '0' and dy.org_subjection_id like 'C105%') t where 1 = 1 and t.project_type in ('5000100004000000001', '5000100004000000002', '5000100004000000010', '5000100004000000007')) t1 on t1.project_info_no =pinfo.project_info_no left join comm_org_subjection orginfo on orginfo.org_id=t1.org_id where pinfo.bsflag='0' and pinfo.REPAIR_START_DATE between to_date('"+startDate+"','yyyy-MM-dd') and to_date('"+endDate+"','yyyy-MM-dd')   and pinfo.project_info_no is not null and dt.bsflag = '0' and dt.device_code is not null " );
		if(StringUtils.isNotBlank(dev_type)){
			sql.append(" and (dt.dev_tree_id like '"+dev_type+"%' ) ");
		}else{
			sql.append(" and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')");
		}
		sql.append(" group by OrgSubIdToName(orginfo.org_subjection_id)) where orgname is not null union all select count(*) num ,repairtype, org_abbreviation from ( select (select coding_name from comm_coding_sort_detail where coding_code_id = info.repair_type) as repairtype, OrgSubIdToName(subinfo.org_subjection_id) org_abbreviation from bgp_comm_device_repair_info info inner join gms_device_account account on account.dev_acc_id = info.device_account_id and account.bsflag = '0' left join dms_device_tree dt on dt.device_code= account.dev_type left join comm_org_information orginfo on orginfo.org_id=account.owning_org_id left join comm_org_subjection subinfo on orginfo.org_id=subinfo.org_id where info.bsflag = '0' and info.REPAIR_START_DATE between to_date('"+startDate+"','yyyy-MM-dd') and to_date('"+endDate+"','yyyy-MM-dd')  and repair_level <> '605' and (info.datafrom <> 'SAP' or info.datafrom is null) and account.owning_sub_id like 'C105%' and account.account_stat in ('0110000013000000003', '0110000013000000001', '0110000013000000006') and dt.bsflag = '0' and dt.device_code is not null " );
		
		if(StringUtils.isNotBlank(dev_type)){
			sql.append(" and (dt.dev_tree_id like '"+dev_type+"%' ) ");
		}else{
			sql.append(" and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')");
		}		
		sql.append(" order by info.repair_start_date desc ) group by repairtype,org_abbreviation ) group by orgname");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "ά�޴���");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		root.addAttribute("staggerLines", "3");
		root.addAttribute("caption", "");

		Element categories = root.addElement("categories");
		Element[] categorys = new Element[list.size()];
		
		Element nx = root.addElement("dataset");
		nx.addAttribute("seriesName", "����");
		nx.addAttribute("color", "45b3ec");
		
		Element wx = root.addElement("dataset");
		wx.addAttribute("seriesName", "����");
		wx.addAttribute("color", "ec4224");
		Element xmwx = root.addElement("dataset");
		xmwx.addAttribute("seriesName", "��Ŀά��");
		xmwx.addAttribute("color", "ffd200");
		int cLevel = Integer.parseInt(level);// ��ǰ��ȡ����
		int nLevel = cLevel + 1;// ��һ��ȡ����
		double uncount = 0;
		double count = 0;
		// ��������
		if (CollectionUtils.isNotEmpty(list)) {
			for (int index = 0; index < list.size(); index++) {
				Map map = (Map) list.get(index);
				Map<String,String> nums=new HashMap<String, String>();
				nums.put("����", "0");
				nums.put("����", "0");
				nums.put("��Ŀά��", "0");
				
				Element set = root.addElement("set");
				 
				categorys[index] = categories.addElement("category");
				String [] totalnum=((String)map.get("num")).split(",");
				String [] repairtype=((String)map.get("repairtype")).split(",");
				for (int i=0;i<totalnum.length;i++) {
					nums.put(repairtype[i], totalnum[i]);
				}
				//categorys[index].addAttribute("label", (String)dataMap.get("projectName"));
				categorys[index].addAttribute("label", (String)map.get("orgname"));//���
				categorys[index].addAttribute("width", "24");
				categories.addAttribute("fontSize", "12");
				
			 
				Element setcjz = nx.addElement("set");//����
				//setcjz.addAttribute("link",  "JavaScript:popDevList('�ɼ�վ','"+(String)map.get("usage_org_name")+"')");
				setcjz.addAttribute("value", nums.get("����"));
				//setcjz.addAttribute("toolText","���� "+totals[0]+"̨,����"+unuse_nums[0]+"̨ ");
				
				Element setjcz = wx.addElement("set");//����
			//	setjcz.addAttribute("link",  "JavaScript:popDevList('����վ','"+(String)map.get("usage_org_name")+"')");
				setjcz.addAttribute("value",nums.get("����"));
				//setjcz.addAttribute("toolText","���� "+totals[1]+"̨,����"+unuse_nums[1]+"̨ ");
				
				Element setdyz = xmwx.addElement("set");//��Ŀά��
				//setdyz.addAttribute("link",  "JavaScript:popDevList('��Դվ','"+(String)map.get("usage_org_name")+"')");
				setdyz.addAttribute("value", nums.get("��Ŀά��"));
				//setdyz.addAttribute("toolText","���� "+totals[2]+"̨,����"+unuse_nums[2]+"̨ ");

			}
		}
		double tempresult = 0;
		if (count >= 0) {
			tempresult = uncount / count;
		}
		 
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 *   ����֤���������Ϣ
	 */
	public ISrvMsg getTaskinst (ISrvMsg isrvmsg) throws Exception {
		log.info("getTaskinst");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String procinst_id=isrvmsg.getValue("procinst_id");//׼������豸�������б�
		 
		String sql="select t4.entity_id,"
       +" t4.proc_name,"
       +" t4.create_user_name,"
       +" t3.node_name,"
       +" decode(t1.state, '2', '���ͨ��', '5', '�˻�', '1', '�����') curState,"
       +" t2.examine_user_name,"
       +" t2.examine_start_date,"
       +" subStr(t2.examine_end_date, 0, 11) examine_end_date,"
       +" t1.is_open,"
       +" t2.examine_info"
  +" from wf_r_taskinst t1"
 +" inner join (select max(taskinst_id) taskinst_id,"
                   +"  wmsys.wm_concat(examine_user_name) examine_user_name,"
                   +"  max(examine_start_date) examine_start_date,"
                  +"    max(examine_end_date) examine_end_date,"
                  +"   max(examine_info) examine_info"
              +"  from wf_r_examineinst"
              +" group by procinst_id, node_id) t2"
    +" on t1.entity_id = t2.taskinst_id"
   +" and t1.procinst_id = '"+procinst_id+"'"
 +" inner join wf_d_node t3"
   +"  on t1.node_id = t3.entity_id"
 +" inner join wf_r_procinst t4"
    +" on t1.procinst_id = t4.entity_id"
 +" order by t2.examine_end_date asc";
		 List<Map> list=jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	} 
  
	/**
	 *   ����֤��ҳ��Ϣ
	 */
	public ISrvMsg getApplyInfoByEmployee_idFY(ISrvMsg isrvmsg) throws Exception {
		log.info("getApplyInfoByEmployee_idFY");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String employee_id=isrvmsg.getValue("employee_id");//׼������豸�������б�
		 
		String sql="   select row_number() over(order by wfmiddle.modifi_date desc ) rowno,devapp.apply_id,dinfo.type,dinfo.name, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date, wfmiddle.proc_inst_id    from (select t1.* from dms_device_opcardapply t1,dms_device_opcardapply_details t2 where t1.apply_id=t2.apply_id and t2.employee_id='"+employee_id+"' " 
         +"  ) devapp   "
          +"  left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id inner join dms_device_opcardapply_dinfo dinfo on devapp.apply_id=dinfo.apply_id  order by wfmiddle.modifi_date desc   nulls last";
		 List<Map> list=jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	} 
	/**
	 *   
	 */
	public ISrvMsg getApplyInfoByEmployee_id(ISrvMsg isrvmsg) throws Exception {
		log.info("getApplyInfoByEmployee_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String employee_id=isrvmsg.getValue("employee_id");//׼������豸�������б�
		 
		String sql="  select row_number() over(order by wfmiddle.modifi_date desc ) rowno,devapp.*, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date   from (select t1.* from dms_device_opcardapply t1,dms_device_opcardapply_details t2 where t1.apply_id=t2.apply_id and t2.employee_id='"+employee_id+"' " 
					+" ) devapp"  
					+" left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id   order by wfmiddle.modifi_date desc nulls last";
		 List<Map> list=jdbcDao.queryRecords(sql);
		 
		responseDTO.setValue("datas", list);
		return responseDTO;
	} 
	/**
	 *  ��ѯ����֤׼������豸������  by employee_id
	 */
	public ISrvMsg getApplyDeviceInfoByEmployee_id(ISrvMsg isrvmsg) throws Exception {
		log.info("getApplyDeviceInfoByEmployee_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String employee_id=isrvmsg.getValue("employee_id");//׼������豸�������б�
		 
		String sql="select  wm_concat(info.type) type, wm_concat(info.name) name "
				+" from DMS_DEVICE_OPCARDAPPLY_DINFO info, dms_device_opcardapply_details d "
				+" where info.apply_id = d.apply_id and d.employee_id = '"+employee_id+"'";
		 Map list=jdbcDao.queryRecordBySQL(sql);
		 
		responseDTO.setValue("data", list);
		return responseDTO;
	}
	 	/**
			 * ��ѯ����֤׼������豸������  by apply_id
			 */
	public ISrvMsg getApplyDeviceInfoByApply_id(ISrvMsg isrvmsg) throws Exception {
				log.info("getApplyDeviceInfoByApply_id");
				ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				String apply_id=isrvmsg.getValue("apply_id");//׼������豸�������б�
				 
				String sql="select   wm_concat(type) type , wm_concat(name) name from DMS_DEVICE_OPCARDAPPLY_DINFO where apply_id='"+apply_id+"'";
				 Map list=jdbcDao.queryRecordBySQL(sql);
				 
				responseDTO.setValue("data", list);
				return responseDTO;
			}
			
	/**
	 * ��ѯ����֤���뵥״̬
	 */
	public ISrvMsg getApplyDeviceInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getApplyDeviceInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String devicelist=isrvmsg.getValue("dev_type_id");//׼������豸�������б�
		String [] devicelists={};
		if(StringUtils.isNotBlank(devicelist)){
			if(devicelist.indexOf(",")!=-1){
				devicelists=devicelist.split(",");
				devicelist="";
				for (int i=0;i<devicelists.length;i++) {
					if(i!=devicelists.length-1){
						devicelist+="'"+devicelists[i]+"',";
					}else{
						devicelist+="'"+devicelists[i]+"'";
					}
				}
			}else{
				devicelist="'"+devicelist+"'";
			}
			
		}
		String sql=" select  t1.device_name||t1.device_type name from dms_device_tree t1 where t1.dev_tree_id in ("+devicelist+")";
		List<Map> list=jdbcDao.queryRecords(sql);
		log.info(list);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * ��ѯ����֤���뵥״̬
	 */
	public ISrvMsg getScrapeState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String apply_id = isrvmsg.getValue("apply_id");// ����֤���뵥ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql
				.append("select devapp.apply_id, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date   from dms_device_opcardapply devapp ");
		queryScrapeInfoSql
				.append(" left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id where 1=1 ");
		// ���뵥ID
		if (StringUtils.isNotBlank(apply_id)) {
			queryScrapeInfoSql.append(" and apply_id  = '" + apply_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql
				.toString());
		if (deviceappMap != null) {
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * ��ѯ�豸����֤���뵥�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOp_cardListOfPerson(ISrvMsg isrvmsg) throws Exception {
		log.info("queryOp_cardListOfPerson");
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
		String employee_id_code_no = isrvmsg.getValue("employee_id");
		String employee_name = isrvmsg.getValue("employee_name");
		String apply_id = isrvmsg.getValue("apply_id");
		
		String sql = " select row_number() over(order by tt.work_date desc) rowno,tt.* ,b.file_id  from ( select * from (select *"
				+ " from (select distinct l.*,"
			 
				+ " d3.coding_name post"
				+ " from (select distinct  "
				+ " '' employee_cd,"
				+ "  l.employee_id_code_no,"
				+ " to_char(l.create_date, 'yyyy-MM-dd')  work_date,"
				+ "  '' org_id,"
				+ "   l.employee_name,"
				+ "   nvl(t1.post, l.post) set_postw,"
				+ "   nvl(t1.apply_team, l.apply_team) set_teamw,"
				+ "   (select org_name from comm_org_information i where i.org_id=owning_org_id) org_name"
				+ "  from bgp_comm_human_labor l"
				+ "  left join (select lt.labor_id, count(1) nu"
				+ "  from bgp_comm_human_labor_list lt"
				+ "  left join bgp_comm_human_labor l"
				+ "     on l.labor_id = lt.labor_id"
				+ "   where lt.bsflag = '0'"
				+ "     and l.bsflag = '0'"
				+ "   group by lt.labor_id) lt"
				+ " on l.labor_id = lt.labor_id"
				+ " left join (select d2.*"
				+ "  from (select d1.*"
				+ "    from (select d.apply_team,"
				+ "                  d.post,"
				+ "                  l1.labor_id,"
				+ "                  row_number() over(partition by l1.labor_id order by d.start_date desc) numa"
				+ "             from bgp_comm_human_deploy_detail d"
				+ "             left join bgp_comm_human_labor_deploy l1"
				+ "               on d.labor_deploy_id ="
				+ "                  l1.labor_deploy_id"
				+ "           where d.bsflag = '0') d1"
				+ "    where d1.numa = 1) d2) t1"
				+ " on l.labor_id = t1.labor_id"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on l.employee_nation = d1.coding_code_id"
				+ "  left join comm_coding_sort_detail d2"
				+ "    on l.employee_education_level = d2.coding_code_id"
				+ " left join (select count(distinct"
				+ "                       to_char(t.start_date, 'yyyy')) years,"
				+ "                 t.labor_id"
				+ "            from bgp_comm_human_labor_deploy t"
				+ "           group by t.labor_id) t"
				+ "  on l.labor_id = t.labor_id"
				+ "  left join bgp_comm_human_certificate cft"
				+ "    on cft.employee_id = l.labor_id"
				+ "    and cft.bsflag = '0'"
				+ "   where l.bsflag = '0'"
				+ "    and l.owning_subjection_org_id like '%C105%') l"
				+ " left join comm_coding_sort_detail d3"
				+ "   on l.set_postw = d3.coding_code_id"
				+ "  left join comm_coding_sort_detail d4"
				+ "    on l.set_teamw = d4.coding_code_id) t"
				+ "   union all "
				+ "   select t.*"
				+ "  from (select h.employee_cd,"
				+ "  e.employee_id_code_no,"
				+ "   to_char(h.work_date, 'yyyy-MM-dd') work_date,"
				+ "   e.org_id,"
				+ "   e.employee_name,"
				+ "   nvl(phr.work_post, h.set_post) set_postw,"
				+ "   nvl(phr.team, h.set_team) set_teamw,"
				+ "   i.org_name org_name,"
				+ "   h.post"
				+ "  from comm_human_employee e"
				+ " inner join comm_human_employee_hr h"
				+ "    on e.employee_id = h.employee_id"
				+ "  left join comm_org_subjection s"
				+ "    on e.org_id = s.org_id"
				+ "   and s.bsflag = '0'"
				+ "  left join comm_org_information i"
				+ "   on e.org_id = i.org_id"
				+ "  and i.bsflag = '0'"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on h.post_level = d1.coding_code_id"
				+ "  and d1.bsflag = '0'"
				+ "   left join comm_coding_sort_detail d2"
				+ "    on e.employee_education_level = d2.coding_code_id"
				+ "    and d2.bsflag = '0'"
				+ "   left join (select d2.*"
				+ "             from (select d1.*"
				+ "                     from (select hr.team,"
				+ "                                 hr.work_post,"
				+ "                               hr.employee_id,"
				+ "                                 hr.actual_start_date,"
				+ "                               hr.actual_end_date,"
				+ "                               row_number() over(partition by hr.employee_id order by hr.actual_end_date desc) numa"
				+ "                          from bgp_project_human_relation hr"
				+ "                         where hr.bsflag = '0'"
				+ "                         and hr.locked_if = '1') d1"
				+ "                 where d1.numa = 1) d2) phr"
				+ "     on e.employee_id = phr.employee_id"
				+ "  left join comm_coding_sort_detail d13"
				+ "    on h.present_state = d13.coding_code_id"
				+ "  left join comm_org_subjection pin"
				+ "    on h.pin_unit = pin.org_subjection_id"
				+ "   and pin.bsflag = '0'"
				+ "  left join bgp_comm_org_hr_gms pin1"
				+ "    on pin1.org_gms_id = pin.org_id"
				+ "  left join bgp_comm_org_hr pin2"
				+ "   on pin2.org_hr_id = pin1.org_hr_id"
				+ "  where e.bsflag = '0'"
				+ "    and h.bsflag = '0'"
				+ "   order by e.modifi_date desc, e.employee_name desc) t"
				+ " left join comm_coding_sort_detail d11"
				+ "    on t.set_teamw = d11.coding_code_id"
				+ "  left join comm_coding_sort_detail d12"
				+ "   on t.set_postw = d12.coding_code_id) temp   where temp.employee_id_code_no in(select distinct EMPLOYEE_ID from dms_device_opcardapply_details where  sfcz='0' ";
		if (StringUtils.isNotBlank(apply_id)) {
			sql += " and apply_id='" + apply_id + "'";
		}
		sql += " )  union all ";

		sql += " select  '' employee_cd,employee_id employee_id_code_no,to_char(work_date, 'yyyy-MM-dd')  work_date, '' org_id,employee_name,'' set_postw ,'' set_teamw, org_name ,post  from dms_device_opcardapply_details where  sfcz='1'";
		if (StringUtils.isNotBlank(apply_id)) {
			sql += " and apply_id='" + apply_id + "'";
		}
		sql += " ) tt left join BGP_DOC_GMS_FILE  b on b.relation_id=employee_id_code_no    where 1=1 ";
		if (StringUtils.isNotBlank(employee_id_code_no)) {
			sql += " and  employee_id_code_no='" + employee_id_code_no + "'";
		}
		if(StringUtils.isNotBlank(employee_name)){
			sql+=" and tt.employee_name='"+employee_name+"'";
		}
		
		page = pureJdbcDao.queryRecordsBySQL(sql, page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ�豸����֤���뵥�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOp_cardList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryOp_cardList");
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
		String apply_no = isrvmsg.getValue("apply_no");// ���뵥��
		String status = isrvmsg.getValue("status");// ���״̬
		String apply_id = isrvmsg.getValue("apply_id");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.apply_id,t.apply_unit,t.apply_date,(select device_name from dms_device_tree where dev_tree_id=op_type) op_type,t.op_model,t.train_content,t.train_teacher,t.train_startdate,t.train_enddate,(case when t2.proc_status='1' then '������' when t2.proc_status='3' then '����ͨ��' when t2.proc_status='4' then '������ͨ��' else 'δ�ύ' end ) as status,t.apply_no,t.apply_person,t.status_date from DMS_DEVICE_OPCARDAPPLY t left join common_busi_wf_middle t2 on apply_id = business_id where 1=1 ");
		// ���뵥��
		if (StringUtils.isNotBlank(apply_no)) {
			querySql.append(" and apply_no='" + apply_no + "'");
		}
		// ���״̬
		if (StringUtils.isNotBlank(status)) {
			querySql.append(" and status='" + status + "'");
		}
		if (StringUtils.isNotBlank(apply_id)) {
			querySql.append(" and apply_id='" + apply_id + "'");
		}
		querySql.append(" order by apply_date desc ");
		log.info(querySql);
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * �����豸���������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUdateOp_cardApply(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUdateOp_cardApply");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map map = new HashMap();
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String nosql = "select devtypeseq.nextval as no from dual";
		Map nomap = pureDao.queryRecordBySQL(nosql);
		String flag = isrvmsg.getValue("flag");
		String apply_id = isrvmsg.getValue("apply_id");
		String devicelist=isrvmsg.getValue("dev_type_id");//׼������豸�������б�
		String [] devicelists={};
		if(StringUtils.isNotBlank(devicelist)){
			if(devicelist.indexOf(",")!=-1){
				devicelists=devicelist.split(",");
				devicelist="";
				for (int i=0;i<devicelists.length;i++) {
					if(i!=devicelists.length-1){
						devicelist+="'"+devicelists[i]+"',";
					}else{
						devicelist+="'"+devicelists[i]+"'";
					}
				}
			}else{
				devicelist="'"+devicelist+"'";
			}
			
		}
		
		if (StringUtils.isNotBlank(apply_id) && !apply_id.equals("null")) {
			map.put("APPLY_ID", apply_id);
		}
		map.put("APPLY_NO", nomap.get("no"));
		map.put("APPLY_PERSON", user.getUserName());
		map.put("APPLY_UNIT", isrvmsg.getValue("org_name"));
		map.put("APPLY_DATE", isrvmsg.getValue("apply_date"));
		//map.put("OP_TYPE", );
		//map.put("OP_MODEL", isrvmsg.getValue("dev_model"));
		map.put("TRAIN_CONTENT", isrvmsg.getValue("train_content"));
		map.put("TRAIN_TEACHER", isrvmsg.getValue("train_teacher"));
		map.put("TRAIN_STARTDATE", isrvmsg.getValue("start_time"));
		map.put("TRAIN_ENDDATE", isrvmsg.getValue("end_time"));
		// map.put("STATUS", "0");
		log.info(map);
		Serializable id = jdbcDao.saveOrUpdateEntity(map,
				"DMS_DEVICE_OPCARDAPPLY");
		String apply_deviceinfosql="select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,(select device_name from dms_device_tree where dev_tree_id= substr(t1.dev_tree_id,0,4) ) type,t1.device_code from dms_device_tree t1 where t1.dev_tree_id in ("+devicelist+") order by t1.code_order   ";
		List<Map> apply_deviceinfomap = pureDao.queryRecords(apply_deviceinfosql);
		for (Map map2 : apply_deviceinfomap) {
			map2.remove("id");
			map2.remove("device_code");
			map2.put("apply_id", id);
		 
			jdbcDao.saveEntity(map2, "DMS_DEVICE_OPCARDAPPLY_DINFO");//�������뵥׼������豸����ͺ�
		}
		int peoplecount = Integer.parseInt(isrvmsg.getValue("peoplecount"));// ������Ա��
		String[] peopleids = isrvmsg.getValue("peopleids").split(",");// �μ���ѵ��id
	
		String[] peopleidss = {};// �μ���ѵ��id
		String[] noimg = {};
		if(StringUtils.isNotBlank(isrvmsg.getValue("peopleidss"))){
			peopleidss = isrvmsg.getValue("peopleidss").split(",");
		}
		if(StringUtils.isNotBlank(isrvmsg.getValue("noimg"))){
			noimg=isrvmsg.getValue("noimg").split(",");// ��Ҫ����ͼƬ�û�
		}
	
		
		// �����ϴ�
		Boolean filesAssetflag = false;
		MQMsgImpl mqMsgAsset = (MQMsgImpl) isrvmsg;
		List<WSFile> filesAsset = mqMsgAsset.getFiles();
		// String [] ids=isrvmsg.getValue("ids").split(",");//�μ���ѵ���ѱ���id
		boolean temp = true;
		for (String string : peopleids) {
			Map userinfo = new HashMap();
			userinfo.put("APPLY_ID", id);
			userinfo.put("EMPLOYEE_ID",
					isrvmsg.getValue("employee_id" + string));
			for (String string1 : peopleidss) {
				if (string.equals(string1)) {
					userinfo.put("SFCZ", "0");
					temp = false;
					break;
				}
			}
			if (temp) {
				userinfo.put("EMPLOYEE_NAME",
						isrvmsg.getValue("employee_name" + string));
				userinfo.put("ORG_NAME", isrvmsg.getValue("work_part" + string));
				userinfo.put("POST", isrvmsg.getValue("org_name" + string));
				userinfo.put("WORK_DATE",
						isrvmsg.getValue("start_work_date" + string));
				userinfo.put("SFCZ", "1");
				userinfo.put("EMPLOYEE_GENDER", isrvmsg.getValue("sex"+string));
			}
			Serializable idd = jdbcDao.saveEntity(userinfo,
					"DMS_DEVICE_OPCARDAPPLY_DETAILS");

			try {
				// ������
				for (WSFile file : filesAsset) {
					String fileOrder = file.getKey().toString();
					if (fileOrder.equals("excel_content_public" + string)) {

						MyUcm ucm = new MyUcm();
						String ucmDocId = ucm.uploadFile(file.getFilename(),
								file.getFileData());
						Map doc = new HashMap();
						doc.put("file_name", file.getFilename());
						doc.put("file_type", file.getKey().toString());
						doc.put("ucm_id", ucmDocId);
						doc.put("is_file", "1");
						doc.put("relation_id",
								isrvmsg.getValue("employee_id" + string));
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date", currentdate);
						doc.put("creator_id", user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id",
								user.getSubOrgIDofAffordOrg());
						String docId = (String) jdbcDao.saveOrUpdateEntity(doc,
								"BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId,
								user.getUserId(), user.getUserId(),
								user.getCodeAffordOrgID(),
								user.getSubOrgIDofAffordOrg(),
								file.getFilename());
						ucm.docLog(docId, "1.0", 1, user.getUserId(),
								user.getUserId(), user.getUserId(),
								user.getCodeAffordOrgID(),
								user.getSubOrgIDofAffordOrg(),
								file.getFilename());
						break;
					}
				}

			} catch (Exception e) {

			}
			temp = true;
		}

		try {
			// ������
			for (WSFile file : filesAsset) {
				String fileOrder = file.getKey().toString();
				if (fileOrder.equals("excel_content_public")) {
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(),
							file.getFileData());
					Map doc = new HashMap();
					doc.put("file_name", file.getFilename());
					doc.put("file_type", file.getKey().toString());
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", id);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date", currentdate);
					doc.put("creator_id", user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc,
							"BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(),
							user.getUserId(), user.getCodeAffordOrgID(),
							user.getSubOrgIDofAffordOrg(), file.getFilename());
					ucm.docLog(docId, "1.0", 1, user.getUserId(),
							user.getUserId(), user.getUserId(),
							user.getCodeAffordOrgID(),
							user.getSubOrgIDofAffordOrg(), file.getFilename());
					break;
				}
			}

		} catch (Exception e) {

		}
		// �����ϴ�
		responseDTO.setValue("result", "1");
		return responseDTO;
	}

	public ISrvMsg loadEmployeeInfoByApplID(ISrvMsg iSrvMsg) throws Exception {
		String apply_id = iSrvMsg.getValue("apply_id");
		String employee_id_code_no = iSrvMsg.getValue("employee_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(iSrvMsg);
		String sql = " select row_number() over(order by tt.work_date desc) rowno,tt.* ,b.file_id from ( select * from (select *"
				+ " from (select distinct l.*,"
			 
				+ " d3.coding_name post"
				+ " from (select distinct  "
				+ " '' employee_cd,"
				+ "  l.employee_id_code_no,"
				+ " to_char(l.create_date, 'yyyy-MM-dd')  work_date,"
				+ "  '' org_id,"
				+ "   l.employee_name,"
				+ "   decode(l.employee_gender, '0', 'Ů', '1', '��') employee_gender,"
				+ "   nvl(t1.post, l.post) set_postw,"
				+ "   nvl(t1.apply_team, l.apply_team) set_teamw,"
				+ "   (select org_name from comm_org_information i where i.org_id=owning_org_id) org_name"
				+ "  from bgp_comm_human_labor l"
				+ "  left join (select lt.labor_id, count(1) nu"
				+ "  from bgp_comm_human_labor_list lt"
				+ "  left join bgp_comm_human_labor l"
				+ "     on l.labor_id = lt.labor_id"
				+ "   where lt.bsflag = '0'"
				+ "     and l.bsflag = '0'"
				+ "   group by lt.labor_id) lt"
				+ " on l.labor_id = lt.labor_id"
				+ " left join (select d2.*"
				+ "  from (select d1.*"
				+ "    from (select d.apply_team,"
				+ "                  d.post,"
				+ "                  l1.labor_id,"
				+ "                  row_number() over(partition by l1.labor_id order by d.start_date desc) numa"
				+ "             from bgp_comm_human_deploy_detail d"
				+ "             left join bgp_comm_human_labor_deploy l1"
				+ "               on d.labor_deploy_id ="
				+ "                  l1.labor_deploy_id"
				+ "           where d.bsflag = '0') d1"
				+ "    where d1.numa = 1) d2) t1"
				+ " on l.labor_id = t1.labor_id"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on l.employee_nation = d1.coding_code_id"
				+ "  left join comm_coding_sort_detail d2"
				+ "    on l.employee_education_level = d2.coding_code_id"
				+ " left join (select count(distinct"
				+ "                       to_char(t.start_date, 'yyyy')) years,"
				+ "                 t.labor_id"
				+ "            from bgp_comm_human_labor_deploy t"
				+ "           group by t.labor_id) t"
				+ "  on l.labor_id = t.labor_id"
				+ "  left join bgp_comm_human_certificate cft"
				+ "    on cft.employee_id = l.labor_id"
				+ "    and cft.bsflag = '0'"
				+ "   where l.bsflag = '0'"
				+ "    and l.owning_subjection_org_id like '%C105%') l"
				+ " left join comm_coding_sort_detail d3"
				+ "   on l.set_postw = d3.coding_code_id"
				+ "  left join comm_coding_sort_detail d4"
				+ "    on l.set_teamw = d4.coding_code_id) t"
				+ "   union all "
				+ "   select t.*"
				+ "  from (select h.employee_cd,"
				+ "  e.employee_id_code_no,"
				+ "   to_char(h.work_date, 'yyyy-MM-dd') work_date,"
				+ "   e.org_id,"
				+ "   e.employee_name,"
				+ "   decode(e.employee_gender, '0', 'Ů', '1', '��') employee_gender,"
				+ "   nvl(phr.work_post, h.set_post) set_postw,"
				+ "   nvl(phr.team, h.set_team) set_teamw,"
				+ "   i.org_name org_name,"
				+ "   h.post"
				+ "  from comm_human_employee e"
				+ " inner join comm_human_employee_hr h"
				+ "    on e.employee_id = h.employee_id"
				+ "  left join comm_org_subjection s"
				+ "    on e.org_id = s.org_id"
				+ "   and s.bsflag = '0'"
				+ "  left join comm_org_information i"
				+ "   on e.org_id = i.org_id"
				+ "  and i.bsflag = '0'"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on h.post_level = d1.coding_code_id"
				+ "  and d1.bsflag = '0'"
				+ "   left join comm_coding_sort_detail d2"
				+ "    on e.employee_education_level = d2.coding_code_id"
				+ "    and d2.bsflag = '0'"
				+ "   left join (select d2.*"
				+ "             from (select d1.*"
				+ "                     from (select hr.team,"
				+ "                                 hr.work_post,"
				+ "                               hr.employee_id,"
				+ "                                 hr.actual_start_date,"
				+ "                               hr.actual_end_date,"
				+ "                               row_number() over(partition by hr.employee_id order by hr.actual_end_date desc) numa"
				+ "                          from bgp_project_human_relation hr"
				+ "                         where hr.bsflag = '0'"
				+ "                         and hr.locked_if = '1') d1"
				+ "                 where d1.numa = 1) d2) phr"
				+ "     on e.employee_id = phr.employee_id"
				+ "  left join comm_coding_sort_detail d13"
				+ "    on h.present_state = d13.coding_code_id"
				+ "  left join comm_org_subjection pin"
				+ "    on h.pin_unit = pin.org_subjection_id"
				+ "   and pin.bsflag = '0'"
				+ "  left join bgp_comm_org_hr_gms pin1"
				+ "    on pin1.org_gms_id = pin.org_id"
				+ "  left join bgp_comm_org_hr pin2"
				+ "   on pin2.org_hr_id = pin1.org_hr_id"
				+ "  where e.bsflag = '0'"
				+ "    and h.bsflag = '0'"
				+ "   order by e.modifi_date desc, e.employee_name desc) t"
				+ " left join comm_coding_sort_detail d11"
				+ "    on t.set_teamw = d11.coding_code_id"
				+ "  left join comm_coding_sort_detail d12"
				+ "   on t.set_postw = d12.coding_code_id) temp   where temp.employee_id_code_no in(select EMPLOYEE_ID from dms_device_opcardapply_details where  sfcz='0' ";
		if (StringUtils.isNotBlank(apply_id)) {
			sql += " and apply_id='" + apply_id + "'";
		}
		sql += " )  union all ";

		sql += " select  '' employee_cd,employee_id employee_id_code_no,to_char(work_date, 'yyyy-MM-dd')  work_date, '' org_id,employee_name,    employee_gender,'' set_postw ,'' set_teamw, org_name ,post  from dms_device_opcardapply_details where  sfcz='1'";
		if (StringUtils.isNotBlank(apply_id)) {
			sql += " and apply_id='" + apply_id + "'";
		}
		sql += " ) tt left join BGP_DOC_GMS_FILE  b on b.relation_id=employee_id_code_no  where 1=1 ";
		if (StringUtils.isNotBlank(employee_id_code_no)) {
			sql += "and  employee_id_code_no='" + employee_id_code_no + "'";
		}
		List<Map> maps = pureDao.queryRecords(sql);
		log.info("ִ��sql:" + sql);
		responseDTO.setValue("datas", maps);
		return responseDTO;
	}

	/**
	 * �����豸����֤�û���Ϣ
	 * 
	 * @param id
	 *            ���֤��
	 * @return
	 */
	public ISrvMsg loadEmployeeInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id = isrvmsg.getValue("employee_id");
		log.info("loadEmployeeInfo");
		String sql = "select * from (select *"
				+ " from (select distinct l.*,"
				+ " d3.coding_name post"
				+ " from (select distinct  "
				+ " '' employee_cd,"
				+ "  l.employee_id_code_no,"
				+ " to_char(l.create_date, 'yyyy-MM-dd')  work_date,"
				+ "  '' org_id,"
				+ "   l.employee_name,"
				+ "   decode(l.employee_gender, '0', 'Ů', '1', '��') employee_gender,"
				+ "   nvl(t1.post, l.post) set_postw,"
				+ "   nvl(t1.apply_team, l.apply_team) set_teamw,"
				+ "   (select org_name from comm_org_information i where i.org_id=owning_org_id) org_name"
				+ "  from bgp_comm_human_labor l"
				+ "  left join (select lt.labor_id, count(1) nu"
				+ "  from bgp_comm_human_labor_list lt"
				+ "  left join bgp_comm_human_labor l"
				+ "     on l.labor_id = lt.labor_id"
				+ "   where lt.bsflag = '0'"
				+ "     and l.bsflag = '0'"
				+ "   group by lt.labor_id) lt"
				+ " on l.labor_id = lt.labor_id"
				+ " left join (select d2.*"
				+ "  from (select d1.*"
				+ "    from (select d.apply_team,"
				+ "                  d.post,"
				+ "                  l1.labor_id,"
				+ "                  row_number() over(partition by l1.labor_id order by d.start_date desc) numa"
				+ "             from bgp_comm_human_deploy_detail d"
				+ "             left join bgp_comm_human_labor_deploy l1"
				+ "               on d.labor_deploy_id ="
				+ "                  l1.labor_deploy_id"
				+ "           where d.bsflag = '0') d1"
				+ "    where d1.numa = 1) d2) t1"
				+ " on l.labor_id = t1.labor_id"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on l.employee_nation = d1.coding_code_id"
				+ "  left join comm_coding_sort_detail d2"
				+ "    on l.employee_education_level = d2.coding_code_id"
				+ " left join (select count(distinct"
				+ "                       to_char(t.start_date, 'yyyy')) years,"
				+ "                 t.labor_id"
				+ "            from bgp_comm_human_labor_deploy t"
				+ "           group by t.labor_id) t"
				+ "  on l.labor_id = t.labor_id"
				+ "  left join bgp_comm_human_certificate cft"
				+ "    on cft.employee_id = l.labor_id"
				+ "    and cft.bsflag = '0'"
				+ "   where l.bsflag = '0'"
				+ "    and l.owning_subjection_org_id like '%C105%') l"
				+ " left join comm_coding_sort_detail d3"
				+ "   on l.set_postw = d3.coding_code_id"
				+ "  left join comm_coding_sort_detail d4"
				+ "    on l.set_teamw = d4.coding_code_id) t"
				+ "   union all "
				+ "   select t.*"
				+ "  from (select h.employee_cd,"
				+ "  e.employee_id_code_no,"
				+ "   to_char(h.work_date, 'yyyy-MM-dd') work_date,"
				+ "   e.org_id,"
				+ "   e.employee_name,"
				+ "   decode(e.employee_gender, '0', 'Ů', '1', '��') employee_gender,"
				+ "   nvl(phr.work_post, h.set_post) set_postw,"
				+ "   nvl(phr.team, h.set_team) set_teamw,"
				+ "   i.org_name org_name,"
				+ "   h.post"
				+ "  from comm_human_employee e"
				+ " inner join comm_human_employee_hr h"
				+ "    on e.employee_id = h.employee_id"
				+ "  left join comm_org_subjection s"
				+ "    on e.org_id = s.org_id"
				+ "   and s.bsflag = '0'"
				+ "  left join comm_org_information i"
				+ "   on e.org_id = i.org_id"
				+ "  and i.bsflag = '0'"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on h.post_level = d1.coding_code_id"
				+ "  and d1.bsflag = '0'"
				+ "   left join comm_coding_sort_detail d2"
				+ "    on e.employee_education_level = d2.coding_code_id"
				+ "    and d2.bsflag = '0'"
				+ "   left join (select d2.*"
				+ "             from (select d1.*"
				+ "                     from (select hr.team,"
				+ "                                 hr.work_post,"
				+ "                               hr.employee_id,"
				+ "                                 hr.actual_start_date,"
				+ "                               hr.actual_end_date,"
				+ "                               row_number() over(partition by hr.employee_id order by hr.actual_end_date desc) numa"
				+ "                          from bgp_project_human_relation hr"
				+ "                         where hr.bsflag = '0'"
				+ "                         and hr.locked_if = '1') d1"
				+ "                 where d1.numa = 1) d2) phr"
				+ "     on e.employee_id = phr.employee_id"
				+ "  left join comm_coding_sort_detail d13"
				+ "    on h.present_state = d13.coding_code_id"
				+ "  left join comm_org_subjection pin"
				+ "    on h.pin_unit = pin.org_subjection_id"
				+ "   and pin.bsflag = '0'"
				+ "  left join bgp_comm_org_hr_gms pin1"
				+ "    on pin1.org_gms_id = pin.org_id"
				+ "  left join bgp_comm_org_hr pin2"
				+ "   on pin2.org_hr_id = pin1.org_hr_id"
				+ "  where e.bsflag = '0'"
				+ "    and h.bsflag = '0'"
				+ "   order by e.modifi_date desc, e.employee_name desc) t"
				+ " left join comm_coding_sort_detail d11"
				+ "    on t.set_teamw = d11.coding_code_id"
				+ "  left join comm_coding_sort_detail d12"
				+ "   on t.set_postw = d12.coding_code_id) temp   where temp.employee_id_code_no='"
				+ id + "'";

		Map map = pureDao.queryRecordBySQL(sql);
		log.info("ִ��sql:" + sql);
		responseDTO.setValue("data", map);
		return responseDTO;

	}

	/**
	 * ��ѯ�豸�����Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevInsList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDevInsList");
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
		String dev_name = isrvmsg.getValue("dev_name");// �豸����
		String dev_model = isrvmsg.getValue("dev_model");// ����ͺ�
		String self_num = isrvmsg.getValue("self_num");// �Ա��
		String license_num = isrvmsg.getValue("license_num");// ���պ�
		String inspection_type = isrvmsg.getValue("inspection_type");// �豸�������
		String project_info_no = isrvmsg.getValue("project_info_no");// ��Ŀid
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.dev_name,t1.dev_model,t1.self_num,t1.license_num,t2.file_name,t2.ucm_id,t3.project_name,t4.org_abbreviation owning_org_name,t5.coding_name inspection_type_name "
				+ " from bgp_comm_device_inspection t "
				+ " left join gms_device_account_dui t1 on t.device_account_id = t1.dev_acc_id "
				+ " left join bgp_doc_gms_file t2 on t2.relation_id = t.inspection_id  and t2.bsflag='0' "
				+ " left join gp_task_project t3 on t.project_info_no = t3.project_info_no "
				+ " left join comm_org_information t4 on t.org_id = t4.org_id "
				+ " left join comm_coding_sort_detail t5 on t.inspection_type = t5.coding_code_id  where t.bsflag='0' ");
		// �豸����
		if (StringUtils.isNotBlank(dev_name)) {
			querySql.append(" and t1.dev_name like '%" + dev_name + "%'");
		}
		// ����ͺ�
		if (StringUtils.isNotBlank(dev_model)) {
			querySql.append(" and t1.dev_model like '%" + dev_model + "%'");
		}
		// �Ա��
		if (StringUtils.isNotBlank(self_num)) {
			querySql.append(" and t1.self_num like '%" + self_num + "%'");
		}
		// ���պ�
		if (StringUtils.isNotBlank(license_num)) {
			querySql.append(" and t1.license_num like '%" + license_num + "%'");
		}
		// �豸�������
		if (StringUtils.isNotBlank(inspection_type)) {
			querySql.append(" and t.inspection_type = '" + inspection_type
					+ "'");
		}
		// �豸�������
		if (StringUtils.isNotBlank(project_info_no)) {
			querySql.append(" and t.project_info_no = '" + project_info_no
					+ "'");
		}
		querySql.append(" order by t.inspection_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * ����id��ѯ�豸�����ϸ��Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevInsInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getDevInsInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String id = isrvmsg.getValue("id");
		String queryRescource = "select t.*,decode(t.spare1,'1','��','0','��'�� spare1_name,t1.dev_name,t1.dev_model,t1.self_num,t1.license_num,t3.project_name,t4.org_abbreviation owning_org_name,t5.coding_name inspection_type_name "
				+ " from bgp_comm_device_inspection t "
				+ " left join gms_device_account_dui t1 on t.device_account_id = t1.dev_acc_id "
				+ " left join gp_task_project t3 on t.project_info_no = t3.project_info_no "
				+ " left join comm_org_information t4 on t.org_id = t4.org_id "
				+ " left join comm_coding_sort_detail t5 on t.inspection_type = t5.coding_code_id  where t.bsflag='0' and t.inspection_id='"
				+ id + "'";
		Map map = jdbcDao.queryRecordBySQL(queryRescource);
		// ��ѯ�ļ���
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ id
				+ "' and t.bsflag='0' and t.is_file='1' order by t.order_num";
		Map fmap = jdbcDao.queryRecordBySQL(sqlFiles);
		responseDTO.setValue("editFileId", id);
		// �豸�������
		responseDTO.setValue("data", map);
		// �豸����Ӧ���ļ�����
		responseDTO.setValue("fdata", fmap);
		return responseDTO;
	}

	/**
	 * ����id��ѯ�豸�����̨����ϸ��Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevAccountInsInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getDevInsInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String id = isrvmsg.getValue("id");
		String queryRescource = "select t.*,decode(t.spare1,'1','��','0','��'�� spare1_name,t1.dev_name,t1.dev_model,t1.self_num,t1.license_num,t4.org_abbreviation owning_org_name,t5.coding_name inspection_type_name "
				+ " from bgp_comm_device_inspection t "
				+ " left join gms_device_account t1 on t.device_account_id = t1.dev_acc_id "
				+ " left join comm_org_information t4 on t.org_id = t4.org_id "
				+ " left join comm_coding_sort_detail t5 on t.inspection_type = t5.coding_code_id  where t.bsflag='0' and t.inspection_id='"
				+ id + "'";
		Map map = jdbcDao.queryRecordBySQL(queryRescource);
		// ��ѯ�ļ���
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ id
				+ "' and t.bsflag='0' and t.is_file='1' order by t.order_num";
		Map fmap = jdbcDao.queryRecordBySQL(sqlFiles);
		responseDTO.setValue("editFileId", id);
		// �豸�������
		responseDTO.setValue("data", map);
		// �豸����Ӧ���ļ�����
		responseDTO.setValue("fdata", fmap);
		return responseDTO;
	}

	/**
	 * ��ȡ��Ŀ��Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getDevInsInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String project_info_no = isrvmsg.getValue("project_info_no");
		String queryRescource = "select t.project_info_no,t.project_name from gp_task_project t where t.bsflag='0' and t.project_info_no='"
				+ project_info_no + "'";
		Map map = jdbcDao.queryRecordBySQL(queryRescource);
		responseDTO.setValue("editFileId", project_info_no);
		responseDTO.setValue("data", map);
		return responseDTO;
	}

	/**
	 * �������޸��豸�����Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateDevInsInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateDevInsInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map map = new HashMap();
		String flag = isrvmsg.getValue("flag");
		String inspection_id = isrvmsg.getValue("inspection_id");
		if (StringUtils.isNotBlank(inspection_id)
				&& !inspection_id.equals("null")) {
			map.put("inspection_id", inspection_id);
		}
		Date date = new Date();
		map.put("device_account_id", isrvmsg.getValue("device_account_id"));
		map.put("inspection_type", isrvmsg.getValue("inspection_type"));
		map.put("rectification_period",
				isrvmsg.getValue("rectification_period"));
		map.put("charge_person", isrvmsg.getValue("charge_person"));
		map.put("inspector", isrvmsg.getValue("inspector"));
		map.put("inspection_date", isrvmsg.getValue("inspection_date"));
		map.put("spare1", isrvmsg.getValue("spare1"));
		map.put("inspection_content", isrvmsg.getValue("inspection_content"));
		map.put("inspection_result", isrvmsg.getValue("inspection_result"));
		map.put("org_id", isrvmsg.getUserToken().getOrgId());
		map.put("org_subjection_id", isrvmsg.getUserToken()
				.getOrgSubjectionId());
		map.put("rectify_date", isrvmsg.getValue("rectify_date"));
		map.put("rectify_person", isrvmsg.getValue("rectify_person"));
		map.put("rectify_content", isrvmsg.getValue("rectify_content"));
		map.put("project_info_no", isrvmsg.getValue("project_info_no"));
		map.put("updator", isrvmsg.getUserToken().getUserId());// ������
		map.put("modifi_date", date);// ����ʱ��
		if ("add".equals(flag)) {
			map.put("creator", isrvmsg.getUserToken().getUserId());// ������
			map.put("create_date", date);// ����ʱ��
			map.put("bsflag", '0');// ɾ����ʶ
		}
		Serializable id = jdbcDao.saveOrUpdateEntity(map,
				"bgp_comm_device_inspection");

		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		// �����ѡ���ļ�����ִ���ϴ��ĵ���ucm�Ĳ��� to_date('"+today+"','YYYY-MM-DD HH24-mi-ss')
		if (fileList != null && fileList.size() != 0) {
			String querySql = "select * from bgp_doc_gms_file t where t.relation_id='"
					+ id + "'";
			Map queryMap = jdbcDao.queryRecordBySQL(querySql);
			if (queryMap != null) {
				String deleteSql = "delete from bgp_doc_gms_file t where t.relation_id='"
						+ id + "'";
				jdbcDao.executeUpdate(deleteSql);
			}
			String ucmDocId = "";
			if (fileList != null && fileList.size() != 0) {
				WSFile uploadFile = fileList.get(0);
				byte[] uploadData = uploadFile.getFileData();
				ucmDocId = myUcm.uploadFile(uploadFile.getFilename(),
						uploadData);
			}
			String file_id = jdbcDao.generateUUID();
			String relation_id = "";
			if (StringUtils.isNotBlank(inspection_id)
					&& !inspection_id.equals("null")) {
				relation_id = inspection_id;
			} else {
				relation_id = id.toString();
			}
			String file_name = isrvmsg.getValue("file_name");
			if (file_name == null || file_name.trim().equals("")) {
				file_name = "";
			}
			StringBuffer sb = new StringBuffer();

			String folder_id = responseDTO.getValue("folder_id");

			StringBuffer sbSql = new StringBuffer();

			sbSql = new StringBuffer(
					"Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
			sbSql.append("values('").append(file_id).append("','")
					.append(file_name).append("','").append(ucmDocId)
					.append("','").append(relation_id).append("','")
					.append(user.getProjectId()).append("','0',sysdate,'")
					.append(user.getUserId()).append("',sysdate,'")
					.append(user.getUserId()).append("','1','")
					.append(user.getOrgId()).append("','")
					.append(user.getSubOrgIDofAffordOrg())
					.append("','" + folder_id + "','')");

			jdbcDao.executeUpdate(sbSql.toString());

			myUcm.docVersion(file_id, "1.0", ucmDocId, user.getUserId(),
					user.getUserId(), user.getCodeAffordOrgID(),
					user.getSubOrgIDofAffordOrg(), file_name);
			myUcm.docLog(file_id, "1.0", 1, user.getUserId(), user.getUserId(),
					user.getUserId(), user.getCodeAffordOrgID(),
					user.getSubOrgIDofAffordOrg(), file_name);
		}
		String index = isrvmsg.getValue("index");
		if (index == null || index.trim().equals("")) {
			index = "";
		}
		responseDTO.setValue("index", index);
		return responseDTO;
	}

	/**
	 * ɾ���豸�����Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteDevIns(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteDevIns");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";

		String ids = isrvmsg.getValue("ids");
		String[] idStrings = ids.split(",");
		Date date = new Date();
		try {
			for (String id : idStrings) {
				Map map = new HashMap();
				map.put("bsflag", "1");// ɾ����־
				map.put("updator", isrvmsg.getUserToken().getUserId());// ������
				map.put("modifi_date", date);// ����ʱ��
				map.put("inspection_id", id.split("_")[0]);// ����

				jdbcDao.saveOrUpdateEntity(map, "bgp_comm_device_inspection");
				String theUcmId = "";
				String fileName = "";
				String updateSql = "";
				String updateVersion = "";
				String updateLog = "";
				List<Map> listucmIds = (List<Map>) jdbcDao
						.queryRecords("select df.file_id,df.file_name from bgp_doc_gms_file df where df.is_file = '1' and df.bsflag='0' and df.relation_id = '"
								+ id.split("_")[0] + "'");
				for (Map temp : listucmIds) {
					String file_id = temp.get("file_id").toString();
					updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"
							+ file_id + "'";
					updateVersion = "update bgp_doc_file_version g set g.bsflag='1' where g.file_id='"
							+ file_id + "'";
					updateLog = "update bgp_doc_file_log g set g.bsflag='1' where g.file_id='"
							+ file_id + "'";
					if (jdbcDao.executeUpdate(updateSql) > 0) {
						String fileVersion = jdbcDao
								.queryRecordBySQL(
										"select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.file_id= '"
												+ file_id + "'")
								.get("file_version").toString();
						System.out.println("delete, the fileVersion is:"
								+ fileVersion);
						myUcm.docLog(file_id, fileVersion, 4, user.getUserId(),
								user.getUserId(), user.getUserId(),
								user.getCodeAffordOrgID(),
								user.getSubOrgIDofAffordOrg(), fileName);
						jdbcDao.executeUpdate(updateVersion);
						jdbcDao.executeUpdate(updateLog);
					}
				}

			}
		} catch (Exception e) {
			operationFlag = "failed";
		}

		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}

	/**
	 * ��ѯ����Ŀ��Ŀ������ʩ������δ�����豸��Ŀ����Ŀ��
	 * 
	 * @param reqDTO
	 * @return ��Ŀ����
	 * @throws Exception
	 * @author wangzheqin 2015-1-7
	 */
	public ISrvMsg getDeviceHireProjectCount(ISrvMsg msg) throws Exception {
		log.info("getDeviceHireProjectCount");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");

		StringBuffer sb = new StringBuffer();
		String proCount = "";// ��Ŀ��

		// ��ѯʩ����������Ŀ����δ��ɷ�������Ŀ��
		sb.append(
				"select count(*) as proCount from ( select dui.project_info_id from Gp_Task_Project t ")
				.append("join gms_device_account_dui dui on t.project_info_no = dui.project_info_id and dui.bsflag='0' and dui.actual_out_time is null ")
				.append("left join Gp_Task_Project_Dynamic pd on pd.project_info_no = t.project_info_no ")
				.append("where t.project_status in ('5000100001000000005','5000100001000000003') ")
				.append("and pd.org_subjection_id like '")
				.append(orgSubId)
				.append("%' ")
				.append("union select coldui.project_info_id from Gp_Task_Project t join gms_device_coll_account_dui coldui on t.project_info_no = coldui.project_info_id and coldui.bsflag='0' and coldui.unuse_num>0  ")
				.append("left join Gp_Task_Project_Dynamic pd on pd.project_info_no = t.project_info_no ")
				.append("where t.project_status in ('5000100001000000005','5000100001000000003') ")
				.append("and pd.org_subjection_id like '").append(orgSubId)
				.append("%') ");

		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(map)) {
			proCount = map.get("procount").toString();
		}

		responseDTO.setValue("procount", proCount);

		return responseDTO;
	}

	/**
	 * ��ѯͬ���豸
	 * 
	 * @param reqDTO
	 * @return ��Ŀ����
	 * @throws Exception
	 * @author wangzheqin 2015-1-7
	 */
	public ISrvMsg getDeviceSynsCount(ISrvMsg msg) throws Exception {
		log.info("getDeviceSynsCount");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");
		int orgLength = orgSubId.length();

		String count = "";// �豸����
		String str = "";
		// ��ѯͬ���豸
		str = "   select count(*)  as  devcount  from  gms_device_account  t  ";
		str += "     where t.bsflag='I' and t.owning_sub_id like '" + orgSubId
				+ "%' ";
		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			count = map.get("devcount") == null ? "0" : map.get("devcount")
					.toString();
		}
		responseDTO.setValue("count", count);
		return responseDTO;
	}

	/**
	 * ��ѯ����Ŀ��Ŀ������ʩ������δ�����豸��Ŀ���豸����
	 * 
	 * @param reqDTO
	 * @return ��̨δ�����豸��,����δ�����豸��
	 * @throws Exception
	 * @author wangzheqin 2015-1-8
	 */
	public ISrvMsg getDeviceHireDeviceCount(ISrvMsg msg) throws Exception {
		log.info("getDeviceHireDeviceCount");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String projectInfoNo = msg.getValue("projectInfoNo");

		StringBuffer sb = new StringBuffer();
		String deviceCount = "";// ��̨�豸��
		String deviceCollCount = "";// �����豸�ڶ�����

		// //��ѯƥ����豸�ͺ�
		// sb.append("select sd.note from comm_coding_sort_detail sd where coding_sort_id ='5110000165' order by coding_code");
		//
		// List queryList = jdbcDao.queryRecords(sb.toString());
		//
		// sb.setLength(0);//���StringBuffer
		// ��ѯ����Ŀʩ����������Ŀ����δ��ɷ����豸��(��̨)
		sb.append(
				"select count(*) as devicecount from gms_device_account_dui dui left join gp_task_project t on dui.project_info_id = t.project_info_no  ")
				.append("where dui.bsflag='0' and dui.actual_out_time is null and t.project_status in ('5000100001000000005','5000100001000000003')  ")
				.append("and dui.project_info_id = '").append(projectInfoNo)
				.append("'");
		// ָ���豸����
		// if(queryList !=null){
		// for(int i=0;i<queryList.size();i++){
		// Map queryMap = (Map)queryList.get(i);
		// String devType = queryMap.get("note").toString();
		// if(i == queryList.size()-1){
		// sb.append(" dui.dev_type like '").append(devType).append("%')");
		// }else{
		// sb.append(" dui.dev_type like '").append(devType).append("%' or ");
		// }
		// }
		// }

		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(map)) {
			deviceCount = map.get("devicecount").toString();
		}

		// ��ѯ����Ŀʩ����������Ŀ����δ��ɷ����豸��(�����ڶ�����)
		sb.setLength(0);// ���StringBuffer
		sb.append(
				"select sum(dui.unuse_num) as devicecollcount from gms_device_coll_account_dui dui ")
				.append("left join Gp_Task_Project t on t.project_info_no = dui.project_info_id  ")
				.append("where dui.bsflag='0' and dui.unuse_num>0 and t.project_status in ('5000100001000000005','5000100001000000003') ")
				.append("and dui.project_info_id = '").append(projectInfoNo)
				.append("' ");

		Map colMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(colMap)) {
			deviceCollCount = colMap.get("devicecollcount").toString();
		}

		responseDTO.setValue("deviceCount", deviceCount);
		responseDTO.setValue("deviceCollCount", deviceCollCount);

		return responseDTO;
	}

	/**
	 * NEWMETHOD ����Ŀ�����豸ת��
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMultiCollMoveInfowfpa(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String devMoveId = msg.getValue("dev_mov_id");
		String outProjectNo = msg.getValue("out_project_no");
		String inProjectNo = msg.getValue("in_project_no");

		// ��ѯת������
		String querySql = "select t.dev_acc_id,t.mov_num,t.actual_out_time,m.out_project_info_id,m.in_project_info_id from gms_device_move_detail t left join gms_device_move m on t.dev_mov_id=m.dev_mov_id where t.dev_mov_id='"
				+ devMoveId + "'";
		List queryList = jdbcDao.queryRecords(querySql);
		// ����ת��̨������
		for (int i = 0; i < queryList.size(); i++) {
			// 1.����ԭ̨������
			Map queryMap = (Map) queryList.get(i);
			Integer outNum = Integer.parseInt(queryMap.get("mov_num")
					.toString());
			// ����̨����Ϣ
			String collAccountSql = "select * from gms_device_coll_account_dui dui where dui.dev_acc_id='"
					+ queryMap.get("dev_acc_id") + "'";
			Map accountMap = jdbcDao.queryRecordBySQL(collAccountSql);
			Integer useNum = Integer.parseInt(accountMap.get("use_num")
					.toString());
			Integer unuseNum = Integer.parseInt(accountMap.get("unuse_num")
					.toString());
			accountMap.put("use_num", useNum + outNum);
			accountMap.put("unuse_num", unuseNum - outNum);
			if (outNum - unuseNum == 0) {
				accountMap.put("is_leaving", "1");
			}
			jdbcDao.saveOrUpdateEntity(accountMap,
					"gms_device_coll_account_dui");
			// 3.����Ӽ�̨�˶�̬��
			Map<String, Object> duiDymMap = new HashMap<String, Object>();
			duiDymMap.put("opr_type", DevConstants.DYM_OPRTYPE_IN);
			duiDymMap.put("dev_acc_id", queryMap.get("dev_acc_id"));
			duiDymMap.put("receive_num", queryMap.get("mov_num"));
			duiDymMap.put("actual_out_time", queryMap.get("actual_out_time"));
			duiDymMap.put("create_date", currentdate);
			duiDymMap.put("creator", user.getUserId());
			// ����������Ϣ
			jdbcDao.saveOrUpdateEntity(duiDymMap, "gms_device_coll_account_dym");

			// 2.������̨������
			// �����µ���Ŀ���豸̨�ʣ�״̬ΪN����ʾ��������ͨ��֮���޸�Ϊ0��ʾ
			// jdbcDao.executeUpdate("delete from gms_device_coll_account_dui t where t.fk_device_appmix_id='"+devMoveId+"'");
			// ��ѯת����Ŀ�ļƻ���ʼʱ��ͽ���ʱ����Ϊת���豸�ļƻ���ʼʱ��ͽ���ʱ��
			String projectSql = "select d.org_id,t.acquire_start_time,t.acquire_end_time from gp_task_project t "
					+ "left join gp_task_project_dynamic d on t.project_info_no = d.project_info_no and d.bsflag = '0' "
					+ "where t.bsflag = '0' and t.project_info_no='"
					+ queryMap.get("in_project_info_id") + "' ";
			Map projectMap = jdbcDao.queryRecordBySQL(projectSql);
			// ��ѯת���豸��̨����Ϣ
			String devdetSql = "select * from gms_device_coll_account_dui t where t.project_info_id='"
					+ queryMap.get("out_project_info_id")
					+ "'and t.dev_acc_id='" + queryMap.get("dev_acc_id") + "'";
			Map queryDatas = jdbcDao.queryRecordBySQL(devdetSql);
			// ��ѯ��̨���Ƿ����ת�Ƶ��豸
			String newAccSql = "select * from gms_device_coll_account_dui t where t.project_info_id='"
					+ queryMap.get("in_project_info_id")
					+ "'and t.fk_dev_acc_id='"
					+ queryDatas.get("fk_dev_acc_id") + "' ";
			Map queryNewDatas = jdbcDao.queryRecordBySQL(newAccSql);
			Serializable new_dev_acc_id = null;
			// û��ִ������
			if (queryNewDatas == null) {
				queryDatas.put("dev_acc_id", "");
				queryDatas.put("total_num", queryMap.get("mov_num"));
				queryDatas.put("unuse_num", queryMap.get("mov_num"));
				queryDatas.put("use_num", 0);
				queryDatas.put("is_leaving", "0");
				queryDatas.put("project_info_id",
						queryMap.get("in_project_info_id"));
				queryDatas.put("actual_in_time",
						queryMap.get("actual_out_time"));
				queryDatas.put("fk_device_appmix_id", devMoveId);
				queryDatas.put("planning_in_time",
						projectMap.get("acquire_start_time"));
				queryDatas.put("planning_out_time",
						projectMap.get("acquire_end_time"));
				queryDatas.put("bsflag", DevConstants.BSFLAG_NORMAL);
				queryDatas.put("in_org_id", projectMap.get("org_id"));
				queryDatas.put("create_date", currentdate);
				queryDatas.put("creator", user.getEmpId());
				new_dev_acc_id = jdbcDao.saveOrUpdateEntity(queryDatas,
						"gms_device_coll_account_dui");
			} else {
				// ����ִ���ۼ�
				Integer newTotalNum = Integer.parseInt(queryNewDatas.get(
						"total_num").toString());
				Integer newUnuseNum = Integer.parseInt(queryNewDatas.get(
						"unuse_num").toString());
				queryNewDatas.put("total_num", newTotalNum + outNum);
				queryNewDatas.put("unuse_num", newUnuseNum + outNum);
				queryNewDatas.put("modifi_date", currentdate);
				new_dev_acc_id = jdbcDao.saveOrUpdateEntity(queryNewDatas,
						"gms_device_coll_account_dui");
			}

			// �Ӽ�̨�˶�̬�����
			Map<String, Object> dymMap = new HashMap<String, Object>();
			dymMap.put("dev_acc_id", new_dev_acc_id.toString());
			dymMap.put("opr_type", "1");
			dymMap.put("receive_num", queryMap.get("mov_num"));
			dymMap.put("actual_in_time", queryMap.get("actual_out_time"));
			dymMap.put("create_date", currentdate);
			dymMap.put("creator", user.getEmpId());
			jdbcDao.saveOrUpdateEntity(dymMap, "gms_device_coll_account_dym");

		}

		// �����豸ת�Ʊ��е��ύ״̬
		String upmove = "update gms_device_move ve set ve.move_status='1' where ve.dev_mov_id='"
				+ devMoveId + "' ";
		jdbcDao.executeUpdate(upmove);

		// 7.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * ���豸̨�����豸��Ϣ���뵽��������λ�ֳ�����ģ��
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg copyToUnPro(ISrvMsg isrvmsg) throws Exception {
		log.info("copyToUnPro");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String deviceId = isrvmsg.getValue("deviceId");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = isrvmsg.getUserToken();
		// �����豸̨����ʹ��״��---����Ϊ����
		String updateDeviceStateSql = "update GMS_DEVICE_ACCOUNT t set t.using_stat='0110000007000000001' where dev_acc_id = '"
				+ deviceId + "'  ";
		int insertResultForUsingSate = 0;
		insertResultForUsingSate = jdbcDao.executeUpdate(updateDeviceStateSql);
		String insertUnProSql = "insert into GMS_DEVICE_ACCOUNT_UNPRO(DEV_ACC_ID,DEV_CODING,DEV_NAME,ASSET_STAT,DEV_MODEL,  ";
		insertUnProSql += "SELF_NUM,DEV_SIGN,DEV_TYPE,DEV_UNIT,ASSET_CODING,";
		insertUnProSql += "TURN_NUM,ORDER_NUM,ASSET_VALUE,NET_VALUE,CONT_NUM,";
		insertUnProSql += "CURRENCY,TECH_STAT,CAPITAL_SOURCE,OWNING_ORG_ID,OWNING_ORG_NAME,";
		insertUnProSql += "OWNING_SUB_ID,USAGE_ORG_ID,USAGE_ORG_NAME,USAGE_SUB_ID,DEV_POSITION,";
		insertUnProSql += " MANU_FACTUR, PRODUCTING_DATE,ACCOUNT_STAT,LICENSE_NUM,CHASSIS_NUM,";
		insertUnProSql += "ENGINE_NUM,BSFLAG,CREATOR,CREATE_DATE,MODIFIER,";
		insertUnProSql += "MODIFI_DATE,FK_DEV_ACC_ID,IS_LEAVING,IFCOUNTRY,DEV_TEAM,";
		insertUnProSql += "REMARK,SPARE1,SPARE2,SPARE3)    ";
		insertUnProSql += "select SYS_GUID(),t.dev_coding,t.dev_name,t.asset_stat,t.dev_model,";
		insertUnProSql += "t.self_num,t.dev_sign,t.dev_type,t.dev_unit,t.asset_coding,";
		insertUnProSql += "t.turn_num, t.order_num,t.asset_value,t.net_value,t.cont_num,";
		insertUnProSql += "t.currency, t.tech_stat,t.capital_source,t.owning_org_id,t.owning_org_name,";
		insertUnProSql += "t.owning_sub_id, t.usage_org_id,t.usage_org_name,t.usage_sub_id,t.dev_position,";
		insertUnProSql += "t.manu_factur,t.producting_date,t.account_stat,t.license_num,t.chassis_num,";
		insertUnProSql += "t.engine_num,t.bsflag,'" + user.getEmpId()
				+ "',to_date('" + currentdate + "','yyyy-mm-dd hh24:mi:ss'),'"
				+ user.getEmpId() + "',";
		insertUnProSql += " to_date('"
				+ currentdate
				+ "','yyyy-mm-dd hh24:mi:ss'),t.dev_acc_id,'0',t.ifcountry,'', t.remark,t.spare1,t.spare2,t.spare3 ";
		insertUnProSql += "from GMS_DEVICE_ACCOUNT t where dev_acc_id = '"
				+ deviceId + "'";
		// ����ɹ���ʶ
		int insertResult = 0;
		insertResult = jdbcDao.executeUpdate(insertUnProSql);
		if (insertResult > 0 && insertResultForUsingSate > 0) {
			responseDTO.setValue("info", "ת��ɹ�");
			String querySql = "select dev_acc_id from gms_device_account_unpro pro where pro.fk_dev_acc_id='"
					+ deviceId + "'";
			Map map = pureJdbcDao.queryRecordBySQL(querySql);
			if (MapUtils.isNotEmpty(map)) {
				responseDTO.setValue("devId", map.get("dev_acc_id").toString());
			}

		} else {
			responseDTO.setValue("info", "ת��ʧ��");
		}

		return responseDTO;
	}

	/* �����豸ά�ޱ�����¼ */
	public ISrvMsg saveDeviceRepairUnProInfo(ISrvMsg isrvmsg) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		Map codeMap = new HashMap();
		codeMap.put("1", "��");
		codeMap.put("2", "̨");
		codeMap.put("3", "ֻ");
		Map map = new HashMap();
		String repair_info = isrvmsg.getValue("repair_info");
		if (StringUtils.isNotBlank(repair_info) && !repair_info.equals("null")) {
			map.put("repair_info", repair_info);
			String sqlString = "delete from BGP_COMM_DEVICE_REPAIR_DETAIL where repair_info='"
					+ repair_info + "'";
			jdbcDao.executeUpdate(sqlString);
			String sqlString2 = "delete from BGP_COMM_DEVICE_REPAIR_TYPE where repair_info='"
					+ repair_info + "'";
			jdbcDao.executeUpdate(sqlString2);
		}
		map.put("DEVICE_ACCOUNT_ID", isrvmsg.getValue("dev_appdet_id"));
		map.put("REPAIR_TYPE", isrvmsg.getValue("repairType"));
		map.put("REPAIR_ITEM", isrvmsg.getValue("repairItem"));
		map.put("REPAIR_START_DATE", isrvmsg.getValue("REPAIR_START_DATE"));
		map.put("REPAIR_END_DATE", isrvmsg.getValue("REPAIR_END_DATE"));
		map.put("HUMAN_COST", isrvmsg.getValue("HUMAN_COST"));
		map.put("MATERIAL_COST", isrvmsg.getValue("MATERIAL_COST"));
		map.put("CREATOR", isrvmsg.getUserToken().getUserName());
		map.put("REPAIRER", isrvmsg.getValue("REPAIRER"));
		map.put("ACCEPTER", isrvmsg.getValue("ACCEPTER"));
		map.put("REPAIR_DETAIL", isrvmsg.getValue("REPAIR_DETAIL"));
		map.put("RECORD_STATUS", isrvmsg.getValue("RECORD_STATUS"));
		String mk = (String) jdbcDao.saveOrUpdateEntity(map,
				"BGP_COMM_DEVICE_REPAIR_INFO");
		List rows = isrvmsg.getCheckBoxValues("rows");

		// System.out.println(isrvmsg.getValue("repairItem"));
		if ("0110000038000000015".equals(isrvmsg.getValue("repairItem"))) {
			Map map2 = new HashMap();
			map2.put("NEXT_MAINTAIN_DATE",
					isrvmsg.getValue("REPAIR_START_DATE"));
			map2.put("DEVICE_ACCOUNT_ID", isrvmsg.getValue("dev_appdet_id"));
			jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_MAINTAIN");
		}

		// ������Ŀ--------------------------------����������û��ѡ�е�ѡ��(���ֳֻ�����һ��)
		String qzby_value = isrvmsg.getValue("qzby_value");
		if (qzby_value != null) {
			String temp[] = qzby_value.split(",");
			String[] updateSql = new String[temp.length];
			for (int j = 0; j < temp.length; j++) {
				// Map map1=new HashMap();
				// map1.put("REPAIR_INFO", mk);
				// map1.put("CREATOR_ID", isrvmsg.getUserToken().getUserId());
				// map1.put("CREATE_DATE", new Date());
				// map1.put("UPDATOR_ID", isrvmsg.getUserToken().getUserId());
				// map1.put("MODIFI_DATE", new Date());
				// map1.put("BSFLAG", "0");
				// map1.put("TYPE_ID", temp[j]);//������Ŀ����
				//
				// //�豸������Ŀ�б�
				// jdbcDao.saveOrUpdateEntity(map1,
				// "BGP_COMM_DEVICE_REPAIR_TYPE");

				String sql = "insert into BGP_COMM_DEVICE_REPAIR_TYPE (repair_detail_id,repair_info,creator_id,create_date,updator_id,modifi_date,bsflag,type_id) "
						+ "values((select sys_guid() from dual),'"
						+ mk
						+ "','"
						+ isrvmsg.getUserToken().getUserId()
						+ "',sysdate,'"
						+ isrvmsg.getUserToken().getUserId()
						+ "',sysdate,'0','" + temp[j] + "')";
				updateSql[j] = sql;
			}
			jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		}

		if (rows != null) {
			for (int i = 0; i < rows.size(); i++) {
				Map map1 = new HashMap();
				map1.put("REPAIR_INFO", mk);
				map1.put("CREATOR", isrvmsg.getUserToken().getUserName());
				map1.put("CREATE_DATE", currentdate);
				map1.put("teammat_out_id",
						isrvmsg.getValue("teammat_out_id" + rows.get(i)));// �ƻ�����
				map1.put("MATERIAL_SPEC",
						isrvmsg.getValue("use_info_detail" + rows.get(i)));// ���ĵĲ�������
				map1.put("MATERIAL_NAME",
						isrvmsg.getValue("wz_name" + rows.get(i)));// ��������
				map1.put("MATERIAL_CODING",
						isrvmsg.getValue("wz_id" + rows.get(i)));// ���ϱ��
				map1.put("UNIT_PRICE",
						isrvmsg.getValue("wz_price" + rows.get(i)));// ����
				map1.put("OUT_NUM", isrvmsg.getValue("use_num" + rows.get(i)));// ��������
				map1.put("MATERIAL_AMOUT",
						isrvmsg.getValue("asign_num" + rows.get(i)));// ��������
				map1.put("TOTAL_CHARGE",
						isrvmsg.getValue("total_charge" + rows.get(i)));// �ܼ�

				// �����ӱ�
				jdbcDao.saveOrUpdateEntity(map1,
						"BGP_COMM_DEVICE_REPAIR_DETAIL");
				// Map map2=new HashMap();
				// map2.put("use_info_detail",
				// isrvmsg.getValue("use_info_detail"+rows.get(i)));
				// map2.put("dev_use", "9");
				// jdbcDao.saveOrUpdateEntity(map2,
				// "GMS_MAT_DEVICE_USE_INFO_DETAIL");

			}
		}
		if (isrvmsg.getValue("repairType").toString()
				.equals("0110000037000000002")) {
			// ������һ�εļƻ���������
			// ��ѯ�ƻ�����ʱ��ͱ�������
			String querysql = "select p.planning_out_time,d.coding_name as maintenance_cycle,p.maintenance_cycle as cycle_id from gms_device_account_unpro t"
					+ " left join (gms_device_maintenance_plan p left join comm_coding_sort_detail d on p.maintenance_cycle=d.coding_code_id)"
					+ " on t.dev_acc_id=p.dev_acc_id where t.dev_acc_id='"
					+ isrvmsg.getValue("dev_appdet_id")
					+ "' group by p.planning_out_time,d.coding_name,p.maintenance_cycle";
			Map querymap = jdbcDao.queryRecordBySQL(querysql);
			// ��ѯʵ�ʱ�������
			String getsql = "select count(*) as repair_num from BGP_COMM_DEVICE_REPAIR_INFO info where info.device_account_id='"
					+ isrvmsg.getValue("dev_appdet_id")
					+ "' and info.bsflag='0'";
			Map getmap = jdbcDao.queryRecordBySQL(getsql);
			int repair_num = Integer.parseInt(getmap.get("repair_num")
					.toString()) + 1;
			// ɾ�����α���֮��ļƻ�
			String dletesql = "delete from gms_device_maintenance_plan p where p.dev_acc_id='"
					+ isrvmsg.getValue("dev_appdet_id")
					+ "' and p.plan_num>'"
					+ repair_num + "' ";
			jdbcDao.executeUpdate(dletesql);
			// �����µı��α���֮��ı����ƻ�
			int cyclevalue = Integer.parseInt("".equals(querymap.get(
					"maintenance_cycle").toString()) ? "0" : querymap.get(
					"maintenance_cycle").toString());
			Date date = sdf.parse(isrvmsg.getValue("REPAIR_START_DATE"));// ʵ�ʱ���ʱ��
			Date planning_out_time = sdf.parse(querymap
					.get("planning_out_time").toString());// �豸�ƻ��볡ʱ��
			Date d = date;
			d = DateUtils.addDays(d, cyclevalue);
			if (cyclevalue > 0) {
				int i = 1;
				for (; d.before(planning_out_time);) {
					System.out.println(sdf.format(d));
					Map<String, Object> Map_Maint = new HashMap<String, Object>();
					Map_Maint.put("dev_acc_id",
							isrvmsg.getValue("dev_appdet_id"));
					Map_Maint.put("actual_time", date);
					Map_Maint.put("last_maintenance_time", date);
					Map_Maint
							.put("maintenance_cycle", querymap.get("cycle_id"));
					Map_Maint.put("planning_out_time",
							querymap.get("planning_out_time"));
					Map_Maint.put("plan_date", sdf.format(d));
					Map_Maint.put("plan_num", repair_num + i);
					jdbcDao.saveOrUpdateEntity(Map_Maint,
							"gms_device_maintenance_plan");
					d = DateUtils.addDays(d, cyclevalue);
					i++;
				}
			}
			// ���·�������λ��λ�豸�������͵��ۼ�ֵ(�ۼƹ���ۼ��꾮�߶ȡ��ۼƹ���Сʱ)
			String updateSql = "update gms_device_account_unpro  pro set  pro.mileage = null ,pro.drilling_footage = null,pro.work_hour = null,modifi_date=sysdate where pro.dev_acc_id='"
					+ isrvmsg.getValue("dev_appdet_id") + "' ";
			jdbcDao.executeUpdate(updateSql);
		}
		return responseDTO;
	}

	/**
	 * ��������λ�豸�����ƻ��ƶ�
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savebyjhUnProInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		// ��������λ̨��Id
		String devId = reqDTO.getValue("ids");
		// �豸��������
		String byzq = reqDTO.getValue("byzq");
		// �豸������ֹ����
		String jzrq = reqDTO.getValue("timesheet_date");
		// �ۼ����
		float ljlc_sq = 0;
		String ljlc = reqDTO.getValue("mileage");
		if (!ljlc.equals("")) {
			ljlc_sq = Float.parseFloat(ljlc);
		}
		// �ۼ��꾮����
		float zjjc_sq = 0;
		String zjjc = reqDTO.getValue("drilling_footage");
		if (!zjjc.equals("")) {
			zjjc_sq = Float.parseFloat(zjjc);
		}
		// �ۼƹ���Сʱ
		float gzxs_sq = 0;
		String gzxs = reqDTO.getValue("work_hour");
		if (!gzxs.equals("")) {
			gzxs_sq = Float.parseFloat(gzxs);
		}

		// ��ɾ�����豸֮ǰ�ı����ƻ�
		String deleteSql = "delete from gms_device_maintenance_unplan t where t.dev_acc_id='"
				+ devId + "'";
		jdbcDao.executeUpdate(deleteSql);
		String deleteUSql = "delete from gms_device_maintenance_plan t where t.dev_acc_id='"
				+ devId + "'";
		jdbcDao.executeUpdate(deleteUSql);
		// ���·�������λ��λ�豸�������͵��ۼ�ֵ(�ۼƹ���ۼ��꾮�߶ȡ��ۼƹ���Сʱ)
		String updateSql = "update gms_device_account_unpro  pro set  pro.mileage = null ,pro.drilling_footage = null,pro.work_hour = null,modifi_date=sysdate where pro.dev_acc_id='"
				+ devId + "' ";
		jdbcDao.executeUpdate(updateSql);
		// ��ǰʱ��
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date nowDate = sdf.parse(currentdate);
		// �豸������������
		int cyclevalue = Integer.parseInt("".equals(byzq) ? "0" : byzq);
		if (cyclevalue > 0) {
			// ���������ڣ���������λ�豸id���뱣���ƻ�����
			Date d = nowDate;
			d = DateUtils.addDays(d, cyclevalue);
			int i = 1;
			Date nextbyTime = nowDate;
			Date planEndDate = sdf.parse(jzrq);
			for (; d.before(planEndDate);) {
				String insertPlanSql = "insert into gms_device_maintenance_plan(MAINTENANCE_ID,DEV_ACC_ID,ACTUAL_TIME,LAST_MAINTENANCE_TIME,MAINTENANCE_CYCLE,PLANNING_OUT_TIME,PLAN_DATE,PLAN_NUM)"
						+ "values(SYS_GUID(),'"
						+ devId
						+ "',to_date('"
						+ currentdate
						+ "','yyyy-mm-dd hh24:mi:ss'),to_date('"
						+ currentdate
						+ "','yyyy-mm-dd hh24:mi:ss'),'"
						+ reqDTO.getValue("maintenance_cycle")
						+ "',to_date('"
						+ jzrq
						+ "','yyyy-mm-dd hh24:mi:ss'),to_date('"
						+ sdf.format(d) + "','yyyy-mm-dd'),'" + i + "')";
				jdbcDao.executeUpdate(insertPlanSql.toString());
				d = DateUtils.addDays(d, cyclevalue);
				if (i == 1) {
					nextbyTime = d;
				}
				i++;
			}
			if (i > 1) {
				if (ljlc_sq == 0 && gzxs_sq == 0 && zjjc_sq == 0) {
				} else {
					String insertPlanSql = "insert into gms_device_maintenance_unplan(MAINTENANCE_ID,DEV_ACC_ID,ACTUAL_TIME,LAST_MAINTENANCE_TIME,PLANNING_OUT_TIME,MILEAGE,WORK_HOUR,DRILLING_FOOTAGE,PLAN_DATE)"
							+ "values(SYS_GUID(),'"
							+ devId
							+ "',to_date('"
							+ currentdate
							+ "','yyyy-mm-dd hh24:mi:ss'),to_date('"
							+ currentdate
							+ "','yyyy-mm-dd hh24:mi:ss'),to_date('"
							+ jzrq
							+ "','yyyy-mm-dd hh24:mi:ss'),"
							+ ljlc_sq
							+ ","
							+ gzxs_sq
							+ ","
							+ zjjc_sq
							+ ",to_date('"
							+ sdf.format(nextbyTime) + "','yyyy-mm-dd'))";
					jdbcDao.executeUpdate(insertPlanSql.toString());
				}

			} else {
				String insertPlanSql = "insert into gms_device_maintenance_unplan(MAINTENANCE_ID,DEV_ACC_ID,ACTUAL_TIME,LAST_MAINTENANCE_TIME,PLANNING_OUT_TIME,MILEAGE,WORK_HOUR,DRILLING_FOOTAGE)"
						+ "values(SYS_GUID(),'"
						+ devId
						+ "',to_date('"
						+ currentdate
						+ "','yyyy-mm-dd hh24:mi:ss'),to_date('"
						+ currentdate
						+ "','yyyy-mm-dd hh24:mi:ss'),to_date('"
						+ jzrq
						+ "','yyyy-mm-dd hh24:mi:ss'),"
						+ ljlc_sq
						+ ","
						+ gzxs_sq + "," + zjjc_sq + ")";
				jdbcDao.executeUpdate(insertPlanSql.toString());
			}
		} else {
			String insertPlanSql = "insert into gms_device_maintenance_unplan(MAINTENANCE_ID,DEV_ACC_ID,ACTUAL_TIME,LAST_MAINTENANCE_TIME,PLANNING_OUT_TIME,MILEAGE,WORK_HOUR,DRILLING_FOOTAGE)"
					+ "values(SYS_GUID(),'"
					+ devId
					+ "',to_date('"
					+ currentdate
					+ "','yyyy-mm-dd hh24:mi:ss'),to_date('"
					+ currentdate
					+ "','yyyy-mm-dd hh24:mi:ss'),to_date('"
					+ jzrq
					+ "','yyyy-mm-dd hh24:mi:ss'),"
					+ ljlc_sq
					+ ","
					+ gzxs_sq + "," + zjjc_sq + ")";
			jdbcDao.executeUpdate(insertPlanSql.toString());

		}

		return reqMsg;
	}

	// ��������λ�豸��ת��¼����
	public ISrvMsg saveYz(ISrvMsg isrvmsg) throws Exception {
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		StringBuffer sb = new StringBuffer()
				.append("select * from (select nvl(info.mileage_total,0) as mileage_total from gms_device_operation_info info where  info.dev_acc_id='"
						+ isrvmsg.getValue("ids")
						+ "' and info.modify_date<to_date('"
						+ isrvmsg.getValue("modify_date")
						+ "','YYYY-MM-DD') order by info.modify_date desc) where ROWNUM <= 1  ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		float quan_total_sq = 0;
		if (mainMap != null && mainMap.get("mileage_total") != null) {
			quan_total_sq = Float.parseFloat((String) mainMap
					.get("mileage_total"));
		}
		Number quan_total = 0;
		if (isrvmsg.getValue("mileage").equals(""))
			quan_total = quan_total_sq;
		else {
			quan_total = quan_total_sq
					+ Float.parseFloat(isrvmsg.getValue("mileage"));
		}

		StringBuffer zuanchisql = new StringBuffer()
				.append("select * from (select nvl(info.drilling_footage_total,0) as drilling_footage_total from gms_device_operation_info info where  info.dev_acc_id='"
						+ isrvmsg.getValue("ids")
						+ "' and info.modify_date<to_date('"
						+ isrvmsg.getValue("modify_date")
						+ "','YYYY-MM-DD') order by info.modify_date desc) where ROWNUM <= 1 ");
		Map zuanchiMap = jdbcDao.queryRecordBySQL(zuanchisql.toString());
		float zc_total_sq = 0;
		if (zuanchiMap != null
				&& zuanchiMap.get("drilling_footage_total") != null) {
			zc_total_sq = Float.parseFloat((String) zuanchiMap
					.get("drilling_footage_total"));
		}
		Number zc_total = 0;
		if (isrvmsg.getValue("drilling_footage").equals(""))
			zc_total = zc_total_sq;
		else {
			zc_total = zc_total_sq
					+ Float.parseFloat(isrvmsg.getValue("drilling_footage"));
		}

		StringBuffer shijiansql = new StringBuffer()
				.append("select * from (select nvl(info.work_hour_total,0) as work_hour_total from gms_device_operation_info info where  info.dev_acc_id='"
						+ isrvmsg.getValue("ids")
						+ "' and info.modify_date<to_date('"
						+ isrvmsg.getValue("modify_date")
						+ "','YYYY-MM-DD') order by info.modify_date desc) where ROWNUM <= 1 ");
		Map shijianMap = jdbcDao.queryRecordBySQL(shijiansql.toString());
		float shijian_total_sq = 0;
		if (shijianMap != null && shijianMap.get("work_hour_total") != null) {
			shijian_total_sq = Float.parseFloat((String) shijianMap
					.get("work_hour_total"));
		}
		Number shijian_total = 0;
		if (isrvmsg.getValue("work_hour").equals(""))
			shijian_total = shijian_total_sq;
		else {
			shijian_total = shijian_total_sq
					+ Float.parseFloat(isrvmsg.getValue("work_hour"));
		}
		Map map = new HashMap();
		map.put("dev_acc_id", isrvmsg.getValue("ids"));
		map.put("mileage", isrvmsg.getValue("mileage"));
		map.put("drilling_footage", isrvmsg.getValue("drilling_footage"));
		map.put("work_hour", isrvmsg.getValue("work_hour"));
		map.put("modify_date", isrvmsg.getValue("modify_date"));
		map.put("mileage_total", quan_total);
		map.put("drilling_footage_total", zc_total);
		map.put("work_hour_total", shijian_total);
		jdbcDao.saveOrUpdateEntity(map, "gms_device_operation_info");
		// ��ѯ�����豸ID�е��豸��Ϣ
		String queryDeviceSql = "select p.mileage,p.work_hour,p.drilling_footage from gms_device_account_unpro p where p.dev_acc_id='"
				+ isrvmsg.getValue("ids") + "'";
		Map deviceMap = jdbcDao.queryRecordBySQL(queryDeviceSql.toString());
		// ��ѯ�����豸���Ƿ��ƶ�������¼
		boolean mileage = false;// �Ƿ��ƶ��ۼƹ��ﱣ����Ŀ
		boolean work_hour = false;// �Ƿ��ƶ��ۼƹ���Сʱ������Ŀ
		boolean drilling_footage = false;// �Ƿ��ƶ��ۼ��꾮������Ŀ
		String queryinfoSql = "select p.mileage,p.work_hour,p.drilling_footage from gms_device_maintenance_unplan p where p.dev_acc_id='"
				+ isrvmsg.getValue("ids") + "'";
		Map deviceInfoMap = jdbcDao.queryRecordBySQL(queryinfoSql.toString());
		if (deviceInfoMap != null && deviceInfoMap.get("mileage") != null
				&& !deviceInfoMap.get("mileage").equals("")) {
			mileage = true;
		}
		if (deviceInfoMap != null
				&& deviceInfoMap.get("drilling_footage") != null
				&& !deviceInfoMap.get("drilling_footage").equals("")) {
			drilling_footage = true;
		}
		if (deviceInfoMap != null && deviceInfoMap.get("work_hour") != null
				&& !deviceInfoMap.get("work_hour").equals("")) {
			work_hour = true;
		}

		// �ۼ����
		float ljlc_sq = 0;
		if (deviceMap != null && deviceMap.get("mileage") != null
				&& !deviceMap.get("mileage").equals("")) {
			ljlc_sq = Float.parseFloat((String) deviceMap.get("mileage"));
		}

		// �ۼ��꾮����
		float zjjc_sq = 0;
		if (deviceMap != null && deviceMap.get("drilling_footage") != null
				&& !deviceMap.get("drilling_footage").equals("")) {
			zjjc_sq = Float.parseFloat((String) deviceMap
					.get("drilling_footage"));
		}
		// �ۼƹ���Сʱ
		float gzxs_sq = 0;
		if (deviceMap != null && deviceMap.get("work_hour") != null
				&& !deviceMap.get("work_hour").equals("")) {
			gzxs_sq = Float.parseFloat((String) deviceMap.get("work_hour"));
		}

		if (!isrvmsg.getValue("mileage").equals("")) {
			String updateSql = "update gms_device_operation_info info set info.mileage_total = info.mileage_total+"
					+ isrvmsg.getValue("mileage")
					+ "  where info.dev_acc_id='"
					+ isrvmsg.getValue("ids")
					+ "' and to_char(info.modify_date,'YYYY-MM-DD') > '"
					+ isrvmsg.getValue("modify_date") + "' ";
			jdbcDao.executeUpdate(updateSql);
			if (ljlc_sq > 0) {
				ljlc_sq = ljlc_sq
						+ Float.parseFloat((String) isrvmsg.getValue("mileage"));
			} else {
				ljlc_sq = Float
						.parseFloat((String) isrvmsg.getValue("mileage"));
			}
			if (mileage) {
				String updatemileSql = " update gms_device_account_unpro p set mileage="
						+ ljlc_sq
						+ " where p.dev_acc_id='"
						+ isrvmsg.getValue("ids") + "' ";
				jdbcDao.executeUpdate(updatemileSql);
			}
		}
		if (!isrvmsg.getValue("drilling_footage").equals("")) {
			String updateSql2 = "update gms_device_operation_info info set info.drilling_footage_total = info.drilling_footage_total+"
					+ isrvmsg.getValue("drilling_footage")
					+ " where info.dev_acc_id='"
					+ isrvmsg.getValue("ids")
					+ "' and to_char(info.modify_date,'YYYY-MM-DD') > '"
					+ isrvmsg.getValue("modify_date") + "' ";
			jdbcDao.executeUpdate(updateSql2);
			if (zjjc_sq > 0) {
				zjjc_sq = ljlc_sq
						+ Float.parseFloat((String) isrvmsg
								.getValue("drilling_footage"));
			} else {
				zjjc_sq = Float.parseFloat((String) isrvmsg
						.getValue("drilling_footage"));
			}
			if (drilling_footage) {
				String updatefootSql = "update gms_device_account_unpro p set drilling_footage="
						+ zjjc_sq
						+ " where p.dev_acc_id='"
						+ isrvmsg.getValue("ids") + "' ";
				jdbcDao.executeUpdate(updatefootSql);
			}
		}
		if (!isrvmsg.getValue("work_hour").equals("")) {
			String updateSql3 = "update gms_device_operation_info info set info.work_hour_total = info.work_hour_total+"
					+ isrvmsg.getValue("work_hour")
					+ " where info.dev_acc_id='"
					+ isrvmsg.getValue("ids")
					+ "' and to_char(info.modify_date,'YYYY-MM-DD') > '"
					+ isrvmsg.getValue("modify_date") + "' ";
			jdbcDao.executeUpdate(updateSql3);
			if (gzxs_sq > 0) {
				gzxs_sq = ljlc_sq
						+ Float.parseFloat((String) isrvmsg
								.getValue("work_hour"));
			} else {
				gzxs_sq = Float.parseFloat((String) isrvmsg
						.getValue("work_hour"));
			}
			if (work_hour) {
				String updatework_hourSql = "update gms_device_account_unpro p set work_hour="
						+ gzxs_sq
						+ " where p.dev_acc_id='"
						+ isrvmsg.getValue("ids") + "' ";
				jdbcDao.executeUpdate(updatework_hourSql);
			}
		}

		return responseDTO;
	}

	/**
	 * ɾ������̨�˼�¼
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteUpdate(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String deviceId = isrvmsg.getValue("deviceId");
		System.out.println(deviceId);
		// ������豸�Ĺ����豸��̨�˵�ID ��������̨�˵�ʹ��״��
		String selectFKSql = "select FK_DEV_ACC_ID from GMS_DEVICE_ACCOUNT_UNPRO  where dev_acc_id='"
				+ deviceId + "' ";
		Map deviceMap = jdbcDao.queryRecordBySQL(selectFKSql.toString());
		if (deviceMap != null && deviceMap.get("fk_dev_acc_id") != null) {
			// �����豸��̨�˵�ʹ��״��--����Ϊ����
			String updateStateSql = "update GMS_DEVICE_ACCOUNT t set t.using_stat='0110000007000000002',modifi_date=sysdate where t.dev_acc_id='"
					+ deviceMap.get("fk_dev_acc_id") + "' ";
			jdbcDao.executeUpdate(updateStateSql);
		}
		String updateSql = "update GMS_DEVICE_ACCOUNT_UNPRO t set t.bsflag='1',modifi_date=sysdate,IS_LEAVING='1',MILEAGE = null,WORK_HOUR = null,DRILLING_FOOTAGE = null where t.dev_acc_id='"
				+ deviceId + "'";
		jdbcDao.executeUpdate(updateSql);
		// ɾ�����豸�ı����ƻ�
		String deleteSql = "delete gms_device_maintenance_plan where dev_acc_id='"
				+ deviceId + "'";
		jdbcDao.executeUpdate(deleteSql);
		// ɾ�����豸�ı����ƻ�
		String deleteUnProSql = "delete gms_device_maintenance_unplan where dev_acc_id='"
				+ deviceId + "'";
		jdbcDao.executeUpdate(deleteUnProSql);
		return responseDTO;
	}

	/**
	 * �ر��豸����ҳ��ˢ�����й���ҳ��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg closeAddUnProDevice(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		return responseDTO;
	}

	/**
	 * ��ȡҪ������excel����
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getExcleData(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// ������ʶ
		String exportFlag = msg.getValue("exportFlag");
		// ��Ŀ��
		String projectInfoNo = msg.getValue("projectInfoNo");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		// ������Ŀ����Դ����
		if ("projectzy".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			List<String> projectList = new ArrayList<String>();
			String querySql = "";
			querySql = "select distinct  p.project_info_no, p.project_name"
					+ "    from gms_device_account_dui dui, gp_task_project p"
					+ "    where dui.project_info_id = p.project_info_no"
					+ "      and dui.bsflag = '0'  and dui.is_leaving='0' and dui.actual_out_time is null"
					+ "     and dui.self_num is not null  "
					+ "     and dui.dev_type like 'S062301%'";
			List<Map> projectMapList = this.jdbcDao.queryRecords(querySql);
			for (Map project : projectMapList) {
				String element = project.get("project_info_no") + "~"
						+ project.get("project_name");
				projectList.add(element);
			}

			String preSql = "     select count(*) as num "
					+ "     from gms_device_account_dui dui"
					+ "     where dui.dev_type like 'S062301%'"
					+ "      and dui.bsflag = '0'"
					+ "      and dui.self_num is not null"
					+ "      and dui.project_info_id = '@'";
			for (int i = 0; i < projectList.size(); i++) {
				String value = (String) projectList.get(i);
				String[] strArray = value.split("~");
				String project_info_id = strArray[0];
				String project_name = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				// ִ��Sql
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ����Ŀ��Դ����
				String zyNum = "";
				if (resultMap != null) {
					zyNum = resultMap.get("num") == null ? "0" : resultMap.get(
							"num").toString();
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", project_name);
					data.put("excel_column_val1", zyNum);
					datas.add(data);
				}
			}

			String name = "����Ŀ��Դ����ͳ��";
			String excelName = "����Ŀ��Դ����ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Ŀ����");
			headerList.add("��Դ����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}
		if ("projectbjusedetail".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String args = msg.getValue("args");
			String[] arg = args.split("~");
			// �ֳ����ֳ���־ xcsb fxcsb
			String key = arg[0];
			// �Ա��
			String self_num = arg[1];
			String zcjType = arg[8];
			// ��ĿID ����Ŀ
			String project_info_id = arg[11];
			// �������� code
			String coding_code_id = arg[12];
			// ����ά����ֹʱ��
			String bywx_date_begin = arg[3];
			String byjb = arg[9];
			String wz_id = arg[10];

			String byjbSql = "";
			if (null != byjb && !"".equals(byjb) && !"null".equals(byjb)) {
				byjb = byjb.substring(0, byjb.lastIndexOf(","));
				String str[] = byjb.split(",");
				for (int i = 0; i < str.length; i++) {
					byjbSql += "'" + str[i] + "'" + ",";

				}
				byjbSql = byjbSql.substring(0, byjbSql.lastIndexOf(","));
			}
			// ����ID B,C,D,

			String wz_idSql = "";
			if (null != wz_id && !"".equals(wz_id) && !"null".equals(wz_id)) {
				wz_id = wz_id.substring(0, wz_id.lastIndexOf(","));
				String str[] = wz_id.split(",");
				for (int i = 0; i < str.length; i++) {
					wz_idSql += "'" + str[i] + "'" + ",";
				}
				wz_idSql = wz_idSql.substring(0, wz_idSql.lastIndexOf(","));
			}
			if (null == bywx_date_begin || "".equals(bywx_date_begin)) {
				bywx_date_begin = new SimpleDateFormat("yyyy")
						.format(new Date()) + "-01-01";
			}
			String bywx_date_end = arg[4];
			if (null == bywx_date_end || "".equals(bywx_date_end)) {
				bywx_date_end = new SimpleDateFormat("yyyy-MM-dd")
						.format(new Date());
			}
			// �ۼƹ���Сʱ��ֹʱ��
			String work_hours_begin = arg[5];
			String work_hours_end = arg[6];
			// ��������
			String wz_name = arg[7];
			// Sql �е�IN ��ʽ �Ա��
			String self_nums = "";
			if (null != self_num && !"".equals(self_num)) {
				if (self_num.indexOf(",") > 0) {
					String[] snum = self_num.split(",");
					for (int i = 0; i < snum.length; i++) {
						self_nums += "'" + snum[i] + "'" + ",";
					}
					if (null != self_nums && !"".equals(self_nums)) {
						self_nums = self_nums.substring(0,
								self_nums.lastIndexOf(","));
					}
				} else {
					List<Map> list = jdbcDao
							.queryRecords("select self_num from gms_device_account  where dev_type  like 'S06230101%'  and  bsflag='0' and  self_num  like '%"
									+ self_num + "%'");
					if (null == list) {
						self_nums = "";
					} else {
						for (Map map : list) {
							self_nums += "'" + map.get("self_num").toString()
									+ "'" + ",";
						}
						if (null != self_nums && !"".equals(self_nums)) {
							self_nums = self_nums.substring(0,
									self_nums.lastIndexOf(","));
						}
					}
				}

			}
			if ("xcsb".equals(key)) {
				StringBuffer sql = new StringBuffer(
						"select  d.self_num, i.wz_name,r.actual_price,w.use_num,t.bywx_date "
								+ "   from  gms_device_zy_bywx t left join gms_device_zy_wxbymat w on t.usemat_id=w.usemat_id");
				sql.append("   left join gms_mat_recyclemat_info r on r.wz_id=w.wz_id ");
				sql.append("  left join gms_mat_infomation i on r.wz_id=i.wz_id");
				sql.append("  left join gms_device_account_dui d on  d.dev_acc_id=t.dev_acc_id");
				sql.append("  where r.project_info_id =t.project_info_id  and  r.wz_type='3'  and r.bsflag='0' and r.project_info_id is not null  and t.bsflag='0'  ");
				if (null != self_nums && (!"".equals(self_nums))) {
					sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account_dui  n where n.self_num in ("
							+ self_nums + ") )");
				}
				if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
						&& !"null".equals(bywx_date_begin)) {
					sql.append("   and t.bywx_date>=to_date('"
							+ bywx_date_begin + "','yyyy-mm-dd')");
				}
				if (null != bywx_date_end && (!"".equals(bywx_date_end))
						&& !"null".equals(bywx_date_end)) {
					sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
							+ "','yyyy-mm-dd')");
				}
				if (null != work_hours_begin && (!"".equals(work_hours_begin))
						&& !"null".equals(work_hours_begin)) {
					int begin = Integer.parseInt(work_hours_begin);
					sql.append("   and  to_number( t.work_hours)>=" + begin);
				}
				if (null != work_hours_end && (!"".equals(work_hours_end))
						&& !"null".equals(work_hours_end)) {
					int end = Integer.parseInt(work_hours_end);
					sql.append("   and  to_number( t.work_hours)<=" + end);
				}
				if (null != project_info_id && (!"".equals(project_info_id))
						&& !"null".equals(project_info_id)) {
					sql.append("   and t.project_info_id='" + project_info_id
							+ "'");
				}
				// if (null != wz_name && (!"".equals(wz_name))
				// && !"null".equals(wz_name)) {
				// sql.append("   and t.usemat_id  in (")
				// .append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
				// .append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
				// + wz_name + "%')))");
				//
				// }
				if (null != zcjType && !"".equals(zcjType)
						&& !"null".equals(zcjType)) {
					String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
							+ "')";
					sql.append(zcj_typeSql);
				}

				if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
					String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
					sql.append(wz_id_sql);
				}
				if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
					String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in ("
							+ byjbSql + ")";
					sql.append(by_jb_sql);
				}

				if (null != coding_code_id && (!"".equals(coding_code_id))
						&& !"null".equals(coding_code_id)) {
					sql.append("  and w.coding_code_id='" + coding_code_id
							+ "'");
				}

				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				List<Map> resultList = null;
				try {
					resultList = jdbcDAO.queryRecords(sql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}

				// ƴXML�ĵ�
				if (resultList != null) {
					for (int i = 0; i < resultList.size(); i++) {
						Map tempMap = resultList.get(i);
						// actual_price
						Map data = new HashMap();
						data.put("excel_column_val0", tempMap.get("self_num"));
						data.put("excel_column_val1", tempMap.get("wz_name"));
						data.put("excel_column_val2",
								tempMap.get("actual_price"));
						data.put("excel_column_val3", tempMap.get("use_num"));
						data.put("excel_column_val4", tempMap.get("bywx_date"));
						datas.add(data);

					}
				}

			} else if ("fxcsb".equals(key)) {
				StringBuffer sql = new StringBuffer(
						"select  d.self_num, i.wz_name,r.actual_price,w.use_num,t.bywx_date "
								+ "   from  gms_device_zy_bywx t left join gms_device_zy_wxbymat w on t.usemat_id=w.usemat_id");
				sql.append("   left join gms_mat_recyclemat_info r on r.wz_id=w.wz_id ");
				sql.append("  left join gms_mat_infomation i on r.wz_id=i.wz_id");
				sql.append("  left join gms_device_account d on  d.dev_acc_id=t.dev_acc_id");
				sql.append("  where r.wz_type='3'  and r.bsflag='0'   and r.project_info_id is  null and t.bsflag='0'");
				if (null != self_nums && (!"".equals(self_nums))) {
					sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account  n where n.self_num in ("
							+ self_nums + ") )");
				}
				if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
						&& !"null".equals(bywx_date_begin)) {
					sql.append("   and t.bywx_date>=to_date('"
							+ bywx_date_begin + "','yyyy-mm-dd')");
				}
				if (null != bywx_date_end && (!"".equals(bywx_date_end))
						&& !"null".equals(bywx_date_end)) {
					sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
							+ "','yyyy-mm-dd')");
				}
				if (null != work_hours_begin && (!"".equals(work_hours_begin))
						&& !"null".equals(work_hours_begin)) {
					int begin = Integer.parseInt(work_hours_begin);
					sql.append("   and  to_number( t.work_hours)>=" + begin);
				}
				if (null != work_hours_end && (!"".equals(work_hours_end))
						&& !"null".equals(work_hours_end)) {
					int end = Integer.parseInt(work_hours_end);
					sql.append("   and  to_number( t.work_hours)<=" + end);
				}
				if (null != project_info_id && (!"".equals(project_info_id))
						&& !"null".equals(project_info_id)) {
					if ("dbwxz".equals(project_info_id)) {
						project_info_id = "����ά����";
						sql.append("   and t.repair_unit='" + project_info_id
								+ "'");
					} else if ("xbwxz".equals(project_info_id)) {
						project_info_id = "����ά����";
						sql.append("   and t.repair_unit='" + project_info_id
								+ "'");
					} else if ("qt".equals(project_info_id)) {
						project_info_id = "����";
						sql.append("   and t.repair_unit  not in ('����ά����','����ά����')");
					}
					sql.append("   and t.project_info_id is  null");
				}
				// if (null != wz_name && (!"".equals(wz_name))
				// && !"null".equals(wz_name)) {
				// sql.append("   and t.usemat_id  in (")
				// .append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
				// .append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
				// + wz_name + "%')))");
				//
				// }
				if (null != zcjType && !"".equals(zcjType)
						&& !"null".equals(zcjType)) {
					String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
							+ "')";
					sql.append(zcj_typeSql);
				}

				if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
					String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
					sql.append(wz_id_sql);
				}
				if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
					String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in ("
							+ byjbSql + ")";
					sql.append(by_jb_sql);
				}

				if (null != coding_code_id && (!"".equals(coding_code_id))
						&& !"null".equals(coding_code_id)) {
					sql.append("  and w.coding_code_id='" + coding_code_id
							+ "'");
				}

				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				List<Map> resultList = null;
				try {
					resultList = jdbcDAO.queryRecords(sql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}

				// ƴXML�ĵ�
				if (resultList != null) {
					for (int i = 0; i < resultList.size(); i++) {
						Map tempMap = resultList.get(i);
						Map data = new HashMap();
						data.put("excel_column_val0", tempMap.get("self_num"));
						data.put("excel_column_val1", tempMap.get("wz_name"));
						data.put("excel_column_val2",
								tempMap.get("actual_price"));
						data.put("excel_column_val3", tempMap.get("use_num"));
						data.put("excel_column_val4", tempMap.get("bywx_date"));
						datas.add(data);
					}
				}
			}

			String name = "��Դ����������ϸͳ��";
			String excelName = "��Դ����������ϸͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Դ���");
			headerList.add("����");
			headerList.add("����");
			headerList.add("ʹ������");
			headerList.add("����ʱ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		if ("zy14type".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String args = msg.getValue("args");
			String[] arg = args.split("~");
			// �ֳ����ֳ���־ xcsb fxcsb
			String key = arg[0];
			// �Ա��
			String self_num = arg[1];
			// ��ĿID ����Ŀ�����Ƕ���ά����|����ά�޲�
			String project_info_id = arg[11];
			String zcjType = arg[8];
			// ����ά����ֹʱ��
			String bywx_date_begin = arg[3];

			String byjb = arg[9];
			String wz_id = arg[10];

			String byjbSql = "";
			if (null != byjb && !"".equals(byjb) && !"null".equals(byjb)) {
				byjb = byjb.substring(0, byjb.lastIndexOf(","));
				String str[] = byjb.split(",");
				for (int i = 0; i < str.length; i++) {
					byjbSql += "'" + str[i] + "'" + ",";

				}
				byjbSql = byjbSql.substring(0, byjbSql.lastIndexOf(","));
			}
			// ����ID B,C,D,

			String wz_idSql = "";
			if (null != wz_id && !"".equals(wz_id) && !"null".equals(wz_id)) {
				wz_id = wz_id.substring(0, wz_id.lastIndexOf(","));
				String str[] = wz_id.split(",");
				for (int i = 0; i < str.length; i++) {
					wz_idSql += "'" + str[i] + "'" + ",";
				}
				wz_idSql = wz_idSql.substring(0, wz_idSql.lastIndexOf(","));
			}
			if (null == bywx_date_begin || "".equals(bywx_date_begin)) {
				bywx_date_begin = new SimpleDateFormat("yyyy")
						.format(new Date()) + "-01-01";
			}
			String bywx_date_end = arg[4];
			if (null == bywx_date_end || "".equals(bywx_date_end)) {
				bywx_date_end = new SimpleDateFormat("yyyy-MM-dd")
						.format(new Date());
			}
			// �ۼƹ���Сʱ��ֹʱ��
			String work_hours_begin = arg[5];
			String work_hours_end = arg[6];
			// ��������
			String wz_name = arg[7];
			// Sql �е�IN ��ʽ �Ա��
			String self_nums = "";
			if (null != self_num && !"".equals(self_num)) {
				if (self_num.indexOf(",") > 0) {
					String[] snum = self_num.split(",");
					for (int i = 0; i < snum.length; i++) {
						self_nums += "'" + snum[i] + "'" + ",";
					}
					if (null != self_nums && !"".equals(self_nums)) {
						self_nums = self_nums.substring(0,
								self_nums.lastIndexOf(","));
					}
				} else {
					List<Map> list = jdbcDao
							.queryRecords("select self_num from gms_device_account  where  dev_type  like 'S06230101%'  and  bsflag='0' and   self_num  like '%"
									+ self_num + "%'");
					if (null == list) {
						self_nums = "";
					} else {
						for (Map map : list) {
							self_nums += "'" + map.get("self_num").toString()
									+ "'" + ",";
						}
						if (null != self_nums && !"".equals(self_nums)) {
							self_nums = self_nums.substring(0,
									self_nums.lastIndexOf(","));
						}
					}
				}

			}

			List<String> typeList = new ArrayList<String>();

			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			List<Map> listMap = dao
					.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				String element = map.get("coding_code_id").toString() + "~"
						+ map.get("coding_name");
				typeList.add(element);

			}
			/**
			 * �ֳ���Դ
			 */
			if ("xcsb".equals(key)) {
				// Y��������ͳ��
				StringBuffer sql = new StringBuffer(
						"  select sum(w.use_num*r.actual_price ) as price , w.coding_code_id "
								+ "  from gms_device_zy_bywx t left  join gms_device_zy_wxbymat w "
								+ "   on t.usemat_id=w.usemat_id");
				sql.append("  left join gms_mat_recyclemat_info r on r.wz_id=w.wz_id  ");
				sql.append("   where  t.project_info_id =r.project_info_id  and   w.coding_code_id is not null  and r.wz_type='3'  and r.bsflag='0' and r.project_info_id is not null  and t.bsflag='0' ");
				if (null != self_nums && (!"".equals(self_nums))) {
					sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account_dui  n where n.self_num in ("
							+ self_nums + ") )");
				}
				if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
						&& !"null".equals(bywx_date_begin)) {
					sql.append("   and t.bywx_date>=to_date('"
							+ bywx_date_begin + "','yyyy-mm-dd')");
				}
				if (null != bywx_date_end && (!"".equals(bywx_date_end))
						&& !"null".equals(bywx_date_end)) {
					sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
							+ "','yyyy-mm-dd')");
				}
				if (null != work_hours_begin && (!"".equals(work_hours_begin))
						&& !"null".equals(work_hours_begin)) {
					int begin = Integer.parseInt(work_hours_begin);
					sql.append("   and  to_number( t.work_hours)>=" + begin);
				}
				if (null != work_hours_end && (!"".equals(work_hours_end))
						&& !"null".equals(work_hours_end)) {
					int end = Integer.parseInt(work_hours_end);
					sql.append("   and  to_number( t.work_hours)<=" + end);
				}
				if (null != project_info_id && (!"".equals(project_info_id))
						&& !"null".equals(project_info_id)) {
					sql.append("   and t.project_info_id='" + project_info_id
							+ "'");
				}
				// if (null != wz_name && (!"".equals(wz_name))
				// && !"null".equals(wz_name)) {
				// sql.append("   and t.usemat_id  in (")
				// .append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
				// .append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
				// + wz_name + "%')))");
				//
				// }

				if (null != zcjType && !"".equals(zcjType)
						&& !"null".equals(zcjType)) {
					String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
							+ "')";
					sql.append(zcj_typeSql);
				}

				if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
					String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
					sql.append(wz_id_sql);
				}
				if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
					String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in ("
							+ byjbSql + ")";
					sql.append(by_jb_sql);
				}
				sql.append(" and  w.coding_code_id='@'");
				sql.append(" group  by  w.coding_code_id");

				for (int i = 0; i < typeList.size(); i++) {
					String value = (String) typeList.get(i);
					String[] strArray = value.split("~");
					String id = strArray[0];
					String name = strArray[1];
					StringBuffer selectSql = new StringBuffer();
					String presqli = new String(sql.toString());
					selectSql.append(presqli.replaceAll("@", id));
					IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
					Map resultMap = null;
					try {
						resultMap = jdbcDAO.queryRecordBySQL(selectSql
								.toString());
					} catch (Exception e) {
						// message.append("�������ѯ�����ֶβ�����!");
					}
					// ��ȡ���
					String price = "";
					if (resultMap != null) {
						price = "" + resultMap.get("price");
						Map data = new HashMap();
						data.put("excel_column_val0", name);
						data.put("excel_column_val1", price);
						datas.add(data);

					} else {
						price = "0";
						Map data = new HashMap();
						data.put("excel_column_val0", name);
						data.put("excel_column_val1", price);
						datas.add(data);
					}
				}

			} else if ("fxcsb".equals(key)) {
				// Y��������ͳ��
				StringBuffer sql = new StringBuffer(
						"  select sum(w.use_num*r.actual_price ) as price , w.coding_code_id "
								+ "  from gms_device_zy_bywx t left  join gms_device_zy_wxbymat w "
								+ "   on t.usemat_id=w.usemat_id");
				sql.append("  left join gms_mat_recyclemat_info r on r.wz_id=w.wz_id  ");
				sql.append("   where w.coding_code_id is not null  and r.wz_type='3'   and r.project_info_id is  null   and r.bsflag='0' ");
				if (null != self_nums && (!"".equals(self_nums))) {
					sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account  n where n.self_num in ("
							+ self_nums + ") )");
				}
				if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
						&& !"null".equals(bywx_date_begin)) {
					sql.append("   and t.bywx_date>=to_date('"
							+ bywx_date_begin + "','yyyy-mm-dd')");
				}
				if (null != bywx_date_end && (!"".equals(bywx_date_end))
						&& !"null".equals(bywx_date_end)) {
					sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
							+ "','yyyy-mm-dd')");
				}
				if (null != work_hours_begin && (!"".equals(work_hours_begin))
						&& !"null".equals(work_hours_begin)) {
					int begin = Integer.parseInt(work_hours_begin);
					sql.append("   and  to_number( t.work_hours)>=" + begin);
				}
				if (null != work_hours_end && (!"".equals(work_hours_end))
						&& !"null".equals(work_hours_end)) {
					int end = Integer.parseInt(work_hours_end);
					sql.append("   and  to_number( t.work_hours)<=" + end);
				}
				if (null != project_info_id && (!"".equals(project_info_id))
						&& !"null".equals(project_info_id)) {
					if ("dbwxz".equals(project_info_id)) {
						project_info_id = "����ά����";
						sql.append("   and t.repair_unit='" + project_info_id
								+ "'");
					} else if ("xbwxz".equals(project_info_id)) {
						project_info_id = "����ά����";
						sql.append("   and t.repair_unit='" + project_info_id
								+ "'");
					} else if ("qt".equals(project_info_id)) {
						project_info_id = "����";
						sql.append("   and t.repair_unit  not in ('����ά����','����ά����')");
					}

				}
				// if (null != wz_name && (!"".equals(wz_name))
				// && !"null".equals(wz_name)) {
				// sql.append("   and t.usemat_id  in (")
				// .append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
				// .append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
				// + wz_name + "%')))");
				//
				// }
				if (null != zcjType && !"".equals(zcjType)
						&& !"null".equals(zcjType)) {
					String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
							+ "')";
					sql.append(zcj_typeSql);
				}

				if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
					String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
					sql.append(wz_id_sql);
				}
				if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
					String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in ("
							+ byjbSql + ")";
					sql.append(by_jb_sql);
				}
				sql.append(" and  t.project_info_id  is null ");
				sql.append(" and  w.coding_code_id='@'");
				sql.append(" group  by  w.coding_code_id");

				for (int i = 0; i < typeList.size(); i++) {
					String value = (String) typeList.get(i);
					String[] strArray = value.split("~");
					String id = strArray[0];
					String name = strArray[1];
					StringBuffer selectSql = new StringBuffer();
					String presqli = new String(sql.toString());
					selectSql.append(presqli.replaceAll("@", id));
					IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
					Map resultMap = null;
					try {
						resultMap = jdbcDAO.queryRecordBySQL(selectSql
								.toString());
					} catch (Exception e) {
						// message.append("�������ѯ�����ֶβ�����!");
					}
					// ��ȡ���
					String price = "";
					if (resultMap != null) {
						price = "" + resultMap.get("price");
						Map data = new HashMap();
						data.put("excel_column_val0", name);
						data.put("excel_column_val1", price);
						datas.add(data);

					} else {
						price = "0";
						Map data = new HashMap();
						data.put("excel_column_val0", name);
						data.put("excel_column_val1", price);
						datas.add(data);
					}
				}
			}
			String name = "��Դ������������ͳ��";
			String excelName = "��Դ������������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("����");
			headerList.add("���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		if ("projectuse".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();

			String args = msg.getValue("args");

			String[] arg = args.split("~");
			// �ֳ����ֳ���־ xcsb fxcsb
			String key = arg[0];
			// �Ա��
			String self_num = arg[1];
			// ��ĿID
			String project_info_id = arg[2];
			// ����ά����ֹʱ��
			String bywx_date_begin = arg[3];
			if (null == bywx_date_begin || "".equals(bywx_date_begin)) {
				bywx_date_begin = new SimpleDateFormat("yyyy")
						.format(new Date()) + "-01-01";
			}
			String bywx_date_end = arg[4];
			if (null == bywx_date_end || "".equals(bywx_date_end)) {
				bywx_date_end = new SimpleDateFormat("yyyy-MM-dd")
						.format(new Date());
			}
			// �ۼƹ���Сʱ��ֹʱ��
			String work_hours_begin = arg[5];
			String work_hours_end = arg[6];
			// ��������
			String wz_name = arg[7];
			String zcjType = arg[8];

			String byjb = arg[9];
			String wz_id = arg[10];

			String byjbSql = "";
			if (null != byjb && !"".equals(byjb) && !"null".equals(byjb)) {
				byjb = byjb.substring(0, byjb.lastIndexOf(","));
				String str[] = byjb.split(",");
				for (int i = 0; i < str.length; i++) {
					byjbSql += "'" + str[i] + "'" + ",";

				}
				byjbSql = byjbSql.substring(0, byjbSql.lastIndexOf(","));
			}
			// ����ID B,C,D,

			String wz_idSql = "";
			if (null != wz_id && !"".equals(wz_id) && !"null".equals(wz_id)) {
				wz_id = wz_id.substring(0, wz_id.lastIndexOf(","));
				String str[] = wz_id.split(",");
				for (int i = 0; i < str.length; i++) {
					wz_idSql += "'" + str[i] + "'" + ",";
				}
				wz_idSql = wz_idSql.substring(0, wz_idSql.lastIndexOf(","));
			}
			// Sql �е�IN ��ʽ �Ա��
			String self_nums = "";
			if (null != self_num && !"".equals(self_num)) {
				if (self_num.indexOf(",") > 0) {
					String[] snum = self_num.split(",");
					for (int i = 0; i < snum.length; i++) {
						self_nums += "'" + snum[i] + "'" + ",";
					}
					if (null != self_nums && !"".equals(self_nums)) {
						self_nums = self_nums.substring(0,
								self_nums.lastIndexOf(","));
					}
				} else {
					List<Map> list = jdbcDao
							.queryRecords("select self_num from gms_device_account  where dev_type  like 'S06230101%'  and  bsflag='0' and  self_num  like '%"
									+ self_num + "%'");
					if (null == list) {
						self_nums = "";
					} else {
						for (Map map : list) {
							self_nums += "'" + map.get("self_num").toString()
									+ "'" + ",";
						}
						if (null != self_nums && !"".equals(self_nums)) {
							self_nums = self_nums.substring(0,
									self_nums.lastIndexOf(","));
						}
					}
				}

			}

			// Sql �е�IN ��ʽ ��ĿID
			String project_info_ids = "";
			if (null != project_info_id && !"".equals(project_info_id)
					&& !"null".equals(project_info_id)) {
				String[] pid = project_info_id.split(",");
				for (int i = 0; i < pid.length; i++) {
					project_info_ids += "'" + pid[i] + "'" + ",";
				}
				if (null != project_info_ids && !"".equals(project_info_ids)) {
					project_info_ids = project_info_ids.substring(0,
							project_info_ids.lastIndexOf(","));
				}
			}

			/**
			 * �ֳ��ͷ��ֳ�
			 */

			if ("xcsb".equals(key)) {
				// X ������Ŀ����
				String ProjectSql = "select  distinct  t.project_info_no,t.project_name"
						+ "    from gp_task_project t, gp_task_project_dynamic t2"
						+ "    where t.project_info_no = t2.project_info_no and t.bsflag='0'";
				// + "  and t.acquire_end_time>=to_date('"
				// + bywx_date_begin
				// /+ "','yyyy-mm-dd')"
				// + "  and  t.acquire_end_time<=to_date('"
				// + bywx_date_end + "','yyyy-mm-dd')";
				if (null != project_info_ids && !"".equals(project_info_ids)) {
					ProjectSql += "  and t.project_info_no  in ("
							+ project_info_ids + ")   ";
				} else {
					ProjectSql += "  and t.project_info_no in  ( select project_info_id from gms_device_zy_bywx  t where t.project_info_id  is not null and "
							+ "t.bywx_date>=to_date('"
							+ bywx_date_begin
							+ "','yyyy-mm-dd') and t.bywx_date<=to_date('"
							+ bywx_date_end + "','yyyy-mm-dd'))";
				}
				List<String> projectList = new ArrayList<String>();
				IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
				List<Map> listMap = dao.queryRecords(ProjectSql);
				if (null != listMap) {
					for (int i = 0; i < listMap.size(); i++) {
						Map map = listMap.get(i);
						Object info_no = map.get("project_info_no");
						Object name = map.get("project_name");
						if (null != info_no && null != name) {
							String id = info_no.toString();
							String project_name = name.toString();
							String element = id + "~" + project_name;
							projectList.add(element);
						}

					}
				}

				// Y��������ͳ��
				StringBuffer sql = new StringBuffer(
						"select  sum (b.use_num*c.actual_price) as price  from gms_device_zy_bywx t "
								+ "   left join gms_device_zy_wxbymat b on t.usemat_id=b.usemat_id "
								+ "   left join gms_mat_recyclemat_info  c on c.wz_id=b.wz_id where ");
				sql.append("   c.wz_type='3'  and c.bsflag='0'  and c.project_info_id is not null and  c.project_info_id=t.project_info_id  and t.bsflag='0'");
				if (null != self_nums && (!"".equals(self_nums))) {
					sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account_dui  n where n.self_num in ("
							+ self_nums + ") )");
				}
				if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
						&& !"null".equals(bywx_date_begin)) {
					sql.append("   and t.bywx_date>=to_date('"
							+ bywx_date_begin + "','yyyy-mm-dd')");
				}
				if (null != bywx_date_end && (!"".equals(bywx_date_end))
						&& !"null".equals(bywx_date_end)) {
					sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
							+ "','yyyy-mm-dd')");
				}
				if (null != work_hours_begin && (!"".equals(work_hours_begin))
						&& !"null".equals(work_hours_begin)) {
					int begin = Integer.parseInt(work_hours_begin);
					sql.append("   and  to_number( t.work_hours)>=" + begin);
				}
				if (null != work_hours_end && (!"".equals(work_hours_end))
						&& !"null".equals(work_hours_end)) {
					int end = Integer.parseInt(work_hours_end);
					sql.append("   and  to_number( t.work_hours)<=" + end);
				}
				// if (null != wz_name && (!"".equals(wz_name))
				// && !"null".equals(wz_name)) {
				// sql.append("   and t.usemat_id  in (")
				// .append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
				// .append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
				// + wz_name + "%')))");
				//
				// }

				if (null != zcjType && !"".equals(zcjType)
						&& !"null".equals(zcjType)) {
					String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
							+ "')";
					sql.append(zcj_typeSql);
				}
				if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
					String wz_id_sql = "  and  c.wz_id in (" + wz_idSql + ")";
					sql.append(wz_id_sql);
				}
				if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
					String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in ("
							+ byjbSql + ")";
					sql.append(by_jb_sql);
				}
				sql.append(" and  t.project_info_id='@'");
				for (int i = 0; i < projectList.size(); i++) {
					String value = (String) projectList.get(i);
					String[] strArray = value.split("~");
					String projectCode = strArray[0];
					String projectName = strArray[1];
					StringBuffer selectSql = new StringBuffer();
					String presqli = new String(sql.toString());
					selectSql.append(presqli.replaceAll("@", projectCode));
					IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
					Map resultMap = null;
					try {
						resultMap = jdbcDAO.queryRecordBySQL(selectSql
								.toString());
					} catch (Exception e) {
						// message.append("�������ѯ�����ֶβ�����!");
					}
					// ��ȡ���
					String price = "";
					if (resultMap != null) {
						Map<String, String> data = new HashMap<String, String>();
						price = "" + resultMap.get("price");
						if ("".equals(price)) {
							price = "0";
						}
						data.put("excel_column_val0", projectName);
						data.put("excel_column_val1", price);
						datas.add(data);
					} else {
						price = "0";
						// ƴXML�ĵ�
						Map<String, String> data = new HashMap<String, String>();
						data.put("excel_column_val0", projectName);
						data.put("excel_column_val1", price);
						datas.add(data);
					}
				}

			} else if ("fxcsb".equals(key)) {
				// X ������Ŀ����

				List<String> projectList = new ArrayList<String>();
				IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
				projectList.add("����ά����~����ά����");
				projectList.add("����ά����~����ά����");
				projectList.add("����~����");

				// Y��������ͳ��
				StringBuffer sql = new StringBuffer(
						"select  sum (b.use_num*c.actual_price) as price  from gms_device_zy_bywx t "
								+ "   left join gms_device_zy_wxbymat b on t.usemat_id=b.usemat_id "
								+ "   left join gms_mat_recyclemat_info  c on c.wz_id=b.wz_id where ");
				sql.append("   c.wz_type='3'  and c.bsflag='0'  and c.project_info_id is   null  and t.bsflag='0'");
				if (null != self_nums && (!"".equals(self_nums))) {
					sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account  n where n.self_num in ("
							+ self_nums + ") )");
				}
				if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
						&& !"null".equals(bywx_date_begin)) {
					sql.append("   and t.bywx_date>=to_date('"
							+ bywx_date_begin + "','yyyy-mm-dd')");
				}
				if (null != bywx_date_end && (!"".equals(bywx_date_end))
						&& !"null".equals(bywx_date_end)) {
					sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
							+ "','yyyy-mm-dd')");
				}
				if (null != work_hours_begin && (!"".equals(work_hours_begin))
						&& !"null".equals(work_hours_begin)) {
					int begin = Integer.parseInt(work_hours_begin);
					sql.append("   and  to_number( t.work_hours)>=" + begin);
				}
				if (null != work_hours_end && (!"".equals(work_hours_end))
						&& !"null".equals(work_hours_end)) {
					int end = Integer.parseInt(work_hours_end);
					sql.append("   and  to_number( t.work_hours)<=" + end);
				}
				// if (null != wz_name && (!"".equals(wz_name))
				// && !"null".equals(wz_name)) {
				// sql.append("   and t.usemat_id  in (")
				// .append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
				// .append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
				// + wz_name + "%')))");
				//
				// }

				if (null != zcjType && !"".equals(zcjType)
						&& !"null".equals(zcjType)) {
					String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
							+ "')";
					sql.append(zcj_typeSql);
				}

				if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
					String wz_id_sql = "  and  c.wz_id in (" + wz_idSql + ")";
					sql.append(wz_id_sql);
				}
				if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
					String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in ("
							+ byjbSql + ")";
					sql.append(by_jb_sql);
				}
				sql.append(" and  t.project_info_id is null");
				sql.append(" and  t.repair_unit='@'");

				for (int i = 0; i < projectList.size(); i++) {
					String value = (String) projectList.get(i);
					String[] strArray = value.split("~");
					String projectCode = strArray[0];
					String projectName = strArray[1];
					StringBuffer selectSql = new StringBuffer();
					String presqli = new String(sql.toString());
					if ("����".equals(projectCode)) {
						selectSql.append(presqli.replaceAll(
								"t.repair_unit='@'",
								"  t.repair_unit not in ('����ά����','����ά����')"));
					} else {
						selectSql.append(presqli.replaceAll("@", projectCode));
					}

					IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
					Map resultMap = null;
					try {
						resultMap = jdbcDAO.queryRecordBySQL(selectSql
								.toString());
					} catch (Exception e) {
						// message.append("�������ѯ�����ֶβ�����!");
					}
					// ��ȡ���
					String price = "";
					if (resultMap != null) {
						Map<String, String> data = new HashMap<String, String>();
						price = "" + resultMap.get("price");
						if ("".equals(price)) {
							price = "0";
						}
						data.put("excel_column_val0", projectName);
						data.put("excel_column_val1", price);
						datas.add(data);

					} else {
						price = "0";
						Map<String, String> data = new HashMap<String, String>();
						data.put("excel_column_val0", projectName);
						data.put("excel_column_val1", price);
						datas.add(data);
					}
				}

			}
			String name = "��Դ��������ͳ��";
			String excelName = "��Դ��������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("����");
			headerList.add("���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}

		if ("xcandfxc".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			// �Ա�ż��ϣ�
			String self_num = msg.getValue("self_num");
			// ����ά�޿�ʼʱ��
			String bywx_date_begin = msg.getValue("bywx_date_begin");
			if (null == bywx_date_begin || "".equals(bywx_date_begin)) {
				bywx_date_begin = new SimpleDateFormat("yyyy")
						.format(new Date()) + "-01-01";
			}
			// ����ά�޿�ʼʱ��
			String bywx_date_end = msg.getValue("bywx_date_end");
			if (null == bywx_date_end || "".equals(bywx_date_end)) {
				bywx_date_end = new SimpleDateFormat("yyyy-MM-dd")
						.format(new Date());
			}

			// ��ĿID���ϣ�
			String project_info_id = msg.getValue("project_info_id");
			// �������� ģ����ѯ
			String wz_name = msg.getValue("wz_name");
			// �ۼƹ���Сʱ��ֹʱ��
			String work_hours_begin = msg.getValue("work_hours_begin");
			String work_hours_end = msg.getValue("work_hours_end");

			String self_nums = "";
			if (null != self_num && !"".equals(self_num)) {
				String[] snum = self_num.split(",");
				for (int i = 0; i < snum.length; i++) {
					self_nums += "'" + snum[i] + "'" + ",";
				}
				if (null != self_nums && !"".equals(self_nums)) {
					self_nums = self_nums.substring(0,
							self_nums.lastIndexOf(","));
				}
			}

			String project_info_ids = "";
			if (null != project_info_id && !"".equals(project_info_id)) {
				String[] pid = project_info_id.split(",");
				for (int i = 0; i < pid.length; i++) {
					project_info_ids += "'" + pid[i] + "'" + ",";
				}
				if (null != project_info_ids && !"".equals(project_info_ids)) {
					project_info_ids = project_info_ids.substring(0,
							project_info_ids.lastIndexOf(","));
				}
			}
			StringBuilder sql = new StringBuilder(
					"  select  nvl(price,0) as price ,zytype from (select sum (m.use_num*r.actual_price) as price ,'fxcsb' as zytype"
							+ " from gms_device_zy_bywx t"
							+ " left join gms_device_zy_wxbymat m"
							+ "  on t.usemat_id = m.usemat_id"
							+ "  left join gms_mat_recyclemat_info  r "
							+ "   on r.wz_id=m.wz_id"
							+ "   where t.project_info_id is null");
			sql.append("    and r.wz_type='3'   and r.bsflag='0'   and t.bsflag='0'");
			if (null != self_nums && !"".equals(self_nums)) {
				String self_num_sql = "   and t.fk_dev_acc_id  in (select dev_acc_id from  gms_device_account   where self_num  in ("
						+ self_nums + ") )";
				sql.append(self_num_sql);
			}
			if (null != bywx_date_begin && !"".equals(bywx_date_begin)) {
				String begin = "    and t.bywx_date>=to_date('"
						+ bywx_date_begin + "','yyyy-mm-dd')";
				sql.append(begin);
			}
			if (null != bywx_date_end && !"".equals(bywx_date_end)) {
				String end = "    and t.bywx_date<=to_date('" + bywx_date_end
						+ "','yyyy-mm-dd')";
				sql.append(end);
			}
			if (null != work_hours_begin && !"".equals(work_hours_begin)) {
				int num = Integer.parseInt(work_hours_begin);
				String begin = "  and to_number(t.work_hours)>=" + num;
				sql.append(begin);
			}
			if (null != work_hours_end && !"".equals(work_hours_end)) {
				int num = Integer.parseInt(work_hours_begin);
				String end = "  and to_number(t.work_hours)<=" + num;
				sql.append(end);
			}
			if (null != wz_name && !"".equals(wz_name)) {
				String wz_name_sql = "    and t.usemat_id in (  select wz_id  from  gms_mat_recyclemat_info f where  f.wz_type='3'  and f.bsflag='0'  and  f.wz_id in (  select wz_id from  gms_mat_infomation  where wz_name  like '%"
						+ wz_name + "%'))";
				sql.append(wz_name_sql);
			}
			sql.append(" union all"
					+ "   select sum (m.use_num*r.actual_price) as price ,'xcsb' as zytype"
					+ " from gms_device_zy_bywx t"
					+ " left join gms_device_zy_wxbymat m"
					+ "  on t.usemat_id = m.usemat_id"
					+ "   left join gms_mat_recyclemat_info  r "
					+ "  on r.wz_id=m.wz_id" + "  where 1=1   ");

			if (null != project_info_ids && !"".equals(project_info_ids)) {
				String project_info_id_sql = "  and t.project_info_id in ("
						+ project_info_ids + ")";
				sql.append(project_info_id_sql);

			} else {
				String project_info_id_sql = "    and t.project_info_id is not null  ";
				sql.append(project_info_id_sql);
			}
			sql.append("    and r.wz_type='3'   and r.bsflag=0    and t.bsflag='0'");
			if (null != bywx_date_begin && !"".equals(bywx_date_begin)) {
				String begin = "    and t.bywx_date>=to_date('"
						+ bywx_date_begin + "','yyyy-mm-dd')";
				sql.append(begin);
			}
			if (null != bywx_date_end && !"".equals(bywx_date_end)) {
				String end = "    and t.bywx_date<=to_date('" + bywx_date_end
						+ "','yyyy-mm-dd')";
				sql.append(end);
			}
			if (null != work_hours_begin && !"".equals(work_hours_begin)) {
				int num = Integer.parseInt(work_hours_begin);
				String begin = "  and to_number(t.work_hours)>=" + num;
				sql.append(begin);
			}
			if (null != work_hours_end && !"".equals(work_hours_end)) {
				int num = Integer.parseInt(work_hours_begin);
				String end = "  and to_number(t.work_hours)<=" + num;
				sql.append(end);
			}
			if (null != wz_name && !"".equals(wz_name)) {
				String wz_name_sql = "    and t.usemat_id in (  select wz_id  from  gms_mat_recyclemat_info f where  f.wz_type='3'  and f.bsflag='0'  and  f.wz_id in (  select wz_id from  gms_mat_infomation  where wz_name  like '%"
						+ wz_name + "%'))";
				sql.append(wz_name_sql);
			}

			sql.append(") aa ");
			List<Map> list = jdbcDao.queryRecords(sql.toString());

			Map showMap = new HashMap();
			showMap.put("xcsb", "�ֳ���Դ");
			showMap.put("fxcsb", "���ֳ���Դ");
			for (int i = 0; i < list.size(); i++) {
				Map map = list.get(i);
				Map<String, String> data = new HashMap<String, String>();
				String key = map.get("zytype").toString();
				String label = showMap.get(key).toString();
				String value = map.get("price").toString();
				data.put("excel_column_val0", label);
				data.put("excel_column_val1", value);
				datas.add(data);
			}
			String name = "��Դ��������ͳ��";
			String excelName = "��Դ��������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		if ("zcjghjl".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");
			String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0'";
			String smt_sql = "select self_num,dev_model,dev_type  from  gms_device_account  t where t.dev_acc_id='"
					+ dev_acc_id + "'";
			Map self_num_map = jdbcDao.queryRecordBySQL(smt_sql);
			String self_num = self_num_map.get("self_num") == null ? ""
					: self_num_map.get("self_num").toString();
			String dev_model = self_num_map.get("dev_model") == null ? ""
					: self_num_map.get("dev_model").toString();
			String dev_type = self_num_map.get("dev_type") == null ? ""
					: self_num_map.get("dev_type").toString();
			List<Map> zcjTypes = jdbcDao.queryRecords(sql);
			List<String> zcjStrList = new ArrayList<String>();
			for (Map map : zcjTypes) {
				String id = map.get("coding_code_id").toString();
				String name = map.get("coding_name").toString();
				zcjStrList.add(id + "~" + name);

			}
			String sql2 = "select count(*) as num from gms_device_zy_bywx m, gms_device_zy_wxbymat t"
					+ " where m.usemat_id = t.usemat_id   and m.dev_acc_id = '"
					+ dev_acc_id + "' and m.zcj_type = '@'";
			// ��¼���ĸ�����¼��
			int maxRecord = 0;
			for (Map map : zcjTypes) {
				String id = map.get("coding_code_id").toString();
				String name = map.get("coding_name").toString();
				String str = new String(sql2);
				str = str.replaceAll("@", id);
				Map result = jdbcDao.queryRecordBySQL(str);
				if (Integer.parseInt(result.get("num").toString()) > maxRecord) {
					maxRecord = Integer.parseInt(result.get("num").toString());
				}

			}
			String querySql = "select m.falut_case  from gms_device_zy_bywx      m, gms_device_zy_wxbymat   t,"
					+ " gms_mat_recyclemat_info i,  gms_mat_infomation      mat"
					+ "  where m.usemat_id = t.usemat_id"
					+ "  and t.wz_id = i.wz_id"
					+ "  and i.wz_id = mat.wz_id"
					+ "  and m.dev_acc_id = '"
					+ dev_acc_id
					+ "'"
					+ "  and m.zcj_type ='@'";
			int showNum = 1;

			for (Map map : zcjTypes) {
				String id = map.get("coding_code_id").toString();
				String name = map.get("coding_name").toString();
				String str = new String(querySql);
				str = str.replaceAll("@", id);
				List<Map> resultList = jdbcDao.queryRecords(str);
				Map data = new HashMap();
				data.put("excel_column_val0", showNum);
				data.put("excel_column_val1", name);
				data.put("excel_column_val2", "");
				data.put("excel_column_val3", "");
				for (int k = 0; k < resultList.size(); k++) {
					Map d = resultList.get(k);
					String excel_column_name = "excel_column_val" + (k + 4);
					data.put(excel_column_name, d.get("falut_case"));
				}
				data.put("excel_column_val" + (maxRecord + 5), "");
				datas.add(data);
				showNum++;

			}

			String name = "�ɿ���Դ��Ҫ�ܳɼ���Ϣ��������¼";
			String excelName = "�ɿ���Դ��Ҫ�ܳɼ���Ϣ��������¼.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("����");
			headerList.add("�ͺ�");
			headerList.add("ϵ�к�");
			for (int n = 1; n <= maxRecord; n++) {
				headerList.add("�����¼" + n);
			}
			headerList.add("��ע");
			responseMsg.setValue("self_num", self_num);
			responseMsg.setValue("dev_model", dev_model);
			responseMsg.setValue("dev_type", dev_type);
			responseMsg.setValue("maxRecord", maxRecord);

			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}

		if ("zcjghjldui".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");
			String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0'";
			String smt_sql = "select self_num,dev_model,dev_type  from  gms_device_account_dui  t where t.dev_acc_id='"
					+ dev_acc_id + "'";
			Map self_num_map = jdbcDao.queryRecordBySQL(smt_sql);
			String self_num = self_num_map.get("self_num") == null ? ""
					: self_num_map.get("self_num").toString();
			String dev_model = self_num_map.get("dev_model") == null ? ""
					: self_num_map.get("dev_model").toString();
			String dev_type = self_num_map.get("dev_type") == null ? ""
					: self_num_map.get("dev_type").toString();
			List<Map> zcjTypes = jdbcDao.queryRecords(sql);
			List<String> zcjStrList = new ArrayList<String>();
			for (Map map : zcjTypes) {
				String id = map.get("coding_code_id").toString();
				String name = map.get("coding_name").toString();
				zcjStrList.add(id + "~" + name);

			}
			String sql2 = "select count(*) as num from gms_device_zy_bywx m, gms_device_zy_wxbymat t"
					+ " where m.usemat_id = t.usemat_id   and m.dev_acc_id = '"
					+ dev_acc_id + "' and m.zcj_type = '@'";
			// ��¼���ĸ�����¼��
			int maxRecord = 0;
			for (Map map : zcjTypes) {
				String id = map.get("coding_code_id").toString();
				String name = map.get("coding_name").toString();
				String str = new String(sql2);
				str = str.replaceAll("@", id);
				Map result = jdbcDao.queryRecordBySQL(str);
				if (Integer.parseInt(result.get("num").toString()) > maxRecord) {
					maxRecord = Integer.parseInt(result.get("num").toString());
				}

			}
			String querySql = "select m.falut_case  from gms_device_zy_bywx      m, gms_device_zy_wxbymat   t,"
					+ " gms_mat_recyclemat_info i,  gms_mat_infomation      mat"
					+ "  where m.usemat_id = t.usemat_id"
					+ "  and t.wz_id = i.wz_id"
					+ "  and i.wz_id = mat.wz_id"
					+ "  and m.dev_acc_id = '"
					+ dev_acc_id
					+ "'"
					+ "  and m.zcj_type ='@'";
			int showNum = 1;

			for (Map map : zcjTypes) {
				String id = map.get("coding_code_id").toString();
				String name = map.get("coding_name").toString();
				String str = new String(querySql);
				str = str.replaceAll("@", id);
				List<Map> resultList = jdbcDao.queryRecords(str);
				Map data = new HashMap();
				data.put("excel_column_val0", showNum);
				data.put("excel_column_val1", name);
				data.put("excel_column_val2", "");
				data.put("excel_column_val3", "");
				for (int k = 0; k < resultList.size(); k++) {
					Map d = resultList.get(k);
					String excel_column_name = "excel_column_val" + (k + 4);
					data.put(excel_column_name, d.get("falut_case"));
				}
				data.put("excel_column_val" + (maxRecord + 5), "");
				datas.add(data);
				showNum++;

			}

			String name = "�ɿ���Դ��Ҫ�ܳɼ���Ϣ��������¼";
			String excelName = "�ɿ���Դ��Ҫ�ܳɼ���Ϣ��������¼.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("����");
			headerList.add("�ͺ�");
			headerList.add("ϵ�к�");
			for (int n = 1; n <= maxRecord; n++) {
				headerList.add("�����¼" + n);
			}
			headerList.add("��ע");
			responseMsg.setValue("self_num", self_num);
			responseMsg.setValue("dev_model", dev_model);
			responseMsg.setValue("dev_type", dev_type);
			responseMsg.setValue("maxRecord", maxRecord);

			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}
		if ("zcjjlwx".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");

			String querySql = "select  wx.create_date, wx.worker_unit, wx.performance_desc,wx.bak,t.dev_name,t.self_num,wx.sequence,(select    t.coding_name  from   comm_coding_sort_detail  t where  t.coding_sort_id='5110000187' and t.coding_code_id=wx.zcj_name) as zcj_name ,"
					+ "wx.wx_date,wx.work_hour, d.coding_name as wx_level,wx.wx_content,"
					+ "wx.worker, wx.zcj_model from gms_device_zy_zcjwx wx   left join"
					+ " comm_coding_sort_detail d on d.coding_code_id=wx.wx_level"
					+ " left join gms_device_account t on t.dev_acc_id=wx.dev_acc_id "
					+ "where wx.bsflag='0' and t.dev_acc_id='"
					+ dev_acc_id
					+ "'   order by wx.create_date desc ";
			List<Map> mapList = jdbcDao.queryRecords(querySql);

			for (int i = 0; i < mapList.size(); i++) {
				Map map = mapList.get(i);
				Map data = new HashMap();
				data.put("excel_column_val0", map.get("wx_date"));
				data.put("excel_column_val1", map.get("self_num"));
				data.put("excel_column_val2", map.get("zcj_name"));
				data.put("excel_column_val3", map.get("zcj_model"));
				data.put("excel_column_val4", map.get("sequence"));
				data.put("excel_column_val5", map.get("work_hour"));
				data.put("excel_column_val6", map.get("wx_level"));
				data.put("excel_column_val7", map.get("wx_content"));
				data.put("excel_column_val8", map.get("performance_desc"));
				data.put("excel_column_val9", map.get("worker_unit"));
				data.put("excel_column_val10", map.get("worker"));
				data.put("excel_column_val11", map.get("bak"));

				datas.add(data);
			}
			String name = "�ɿ���Դ��Ҫ�ܳɼ�ά�޼�¼";
			String excelName = "�ɿ���Դ��Ҫ�ܳɼ�ά�޼�¼.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("����");
			headerList.add("�Ա��");
			headerList.add("�ܳɼ�����");
			headerList.add("�ͺ�");
			headerList.add("ϵ�к�");
			headerList.add("�ۼ���תʱ��");
			headerList.add("������");
			headerList.add("��Ҫ��������");
			headerList.add("��Ҫװ��ߴ缰����ָ��");
			headerList.add("��λ");
			headerList.add("������");
			headerList.add("��ע");

			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}

		if ("zcjjlwxdui".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");

			String querySql = "select wx.create_date, wx.worker_unit, wx.performance_desc,wx.bak,t.dev_name,t.self_num,wx.sequence,(select    t.coding_name  from   comm_coding_sort_detail  t where  t.coding_sort_id='5110000187' and t.coding_code_id=wx.zcj_name) as zcj_name ,"
					+ "wx.wx_date,wx.work_hour, d.coding_name as wx_level,wx.wx_content,"
					+ "wx.worker, wx.zcj_model from gms_device_zy_zcjwx wx   left join"
					+ " comm_coding_sort_detail d on d.coding_code_id=wx.wx_level"
					+ " left join gms_device_account t on t.dev_acc_id=wx.dev_acc_id "
					+ "where wx.bsflag='0' and t.dev_acc_id=(select k.fk_dev_acc_id from gms_device_account_dui  k where k.dev_acc_id='"
					+ dev_acc_id + "')  order by wx.create_date desc ";
			List<Map> mapList = jdbcDao.queryRecords(querySql);

			for (int i = 0; i < mapList.size(); i++) {
				Map map = mapList.get(i);
				Map data = new HashMap();
				data.put("excel_column_val0", map.get("wx_date"));
				data.put("excel_column_val1", map.get("self_num"));
				data.put("excel_column_val2", map.get("zcj_name"));
				data.put("excel_column_val3", map.get("zcj_model"));
				data.put("excel_column_val4", map.get("sequence"));
				data.put("excel_column_val5", map.get("work_hour"));
				data.put("excel_column_val6", map.get("wx_level"));
				data.put("excel_column_val7", map.get("wx_content"));
				data.put("excel_column_val8", map.get("performance_desc"));
				data.put("excel_column_val9", map.get("worker_unit"));
				data.put("excel_column_val10", map.get("worker"));
				data.put("excel_column_val11", map.get("bak"));

				datas.add(data);
			}
			String name = "�ɿ���Դ��Ҫ�ܳɼ�ά�޼�¼";
			String excelName = "�ɿ���Դ��Ҫ�ܳɼ�ά�޼�¼.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("����");
			headerList.add("�Ա��");
			headerList.add("�ܳɼ�����");
			headerList.add("�ͺ�");
			headerList.add("ϵ�к�");
			headerList.add("�ۼ���תʱ��");
			headerList.add("������");
			headerList.add("��Ҫ��������");
			headerList.add("��Ҫװ��ߴ缰����ָ��");
			headerList.add("��λ");
			headerList.add("������");
			headerList.add("��ע");

			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}
		// ʩ����������
		if ("kkzysgll".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");

			String querySql = "select pro.project_name,dui.dev_name,dui.asset_coding, dui.actual_in_time, dui.actual_out_time, p.local_temp_low,p.local_temp_height,"
					+ " p.projecter,p.country,p.project_address,p.work_hour,p.surface, dui.dev_model,dui.self_num, org.org_abbreviation,p.construction_method,"
					+ "  p.construction_paramete"
					+ " from gms_device_account_dui dui join gms_device_zy_project p"
					+ "   on p.project_info_id = dui.project_info_id"
					+ " join gp_task_project pro   on dui.project_info_id = pro.project_info_no"
					+ " join gp_task_project_dynamic dy   on dy.project_info_no = pro.project_info_no"
					+ " join comm_org_information org     on org.org_id = dy.org_id"
					+ "   where dui.fk_dev_acc_id = '" + dev_acc_id + "'";
			List<Map> mapList = jdbcDao.queryRecords(querySql);

			for (int i = 0; i < mapList.size(); i++) {
				Map map = mapList.get(i);
				Map data = new HashMap();
				data.put("excel_column_val0", i + 1);
				data.put("excel_column_val1", map.get("dev_model"));
				data.put("excel_column_val2", map.get("self_num"));
				data.put("excel_column_val3", map.get("actual_in_time") + "--"
						+ map.get("actual_out_time"));
				data.put("excel_column_val4",
						map.get("country") + "/" + map.get("project_address"));
				data.put("excel_column_val5", map.get("project_name"));
				data.put("excel_column_val6", map.get("org_abbreviation"));
				data.put("excel_column_val7", map.get("construction_method"));
				data.put("excel_column_val8", map.get("construction_paramete"));
				data.put("excel_column_val9", map.get("surface"));
				data.put("excel_column_val10", map.get("work_hour"));
				data.put("excel_column_val11", map.get("projecter"));

				datas.add(data);
			}
			String name = "�ɿ���Դʩ������";
			String excelName = "�ɿ���Դʩ������.xls";
			List<String> headerList = new ArrayList<String>();

			headerList.add("���");
			headerList.add("�豸�ͺ�");
			headerList.add("�Ա��");
			headerList.add("��ֹʱ��");
			headerList.add("����/����");
			headerList.add("��Ŀ����");
			headerList.add("ʩ���Ӻ�");
			headerList.add("ʩ������");
			headerList.add("ʩ������");
			headerList.add("�ر�����");
			headerList.add("����ʱ��12h/24h");
			headerList.add("��Ŀ��/�鳤");

			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}
		if ("kkzysglldui".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");

			String querySql = "select pro.project_name,dui.dev_name,dui.asset_coding, dui.actual_in_time, dui.actual_out_time, p.local_temp_low,p.local_temp_height,"
					+ " p.projecter,p.country,p.project_address,p.work_hour,p.surface, dui.dev_model,dui.self_num, org.org_abbreviation,p.construction_method,"
					+ "  p.construction_paramete"
					+ " from gms_device_account_dui dui join gms_device_zy_project p"
					+ "   on p.project_info_id = dui.project_info_id"
					+ " join gp_task_project pro   on dui.project_info_id = pro.project_info_no"
					+ " join gp_task_project_dynamic dy   on dy.project_info_no = pro.project_info_no"
					+ " join comm_org_information org     on org.org_id = dy.org_id"
					+ "   where dui.dev_acc_id = '" + dev_acc_id + "'";
			List<Map> mapList = jdbcDao.queryRecords(querySql);

			for (int i = 0; i < mapList.size(); i++) {
				Map map = mapList.get(i);
				Map data = new HashMap();
				data.put("excel_column_val0", i + 1);
				data.put("excel_column_val1", map.get("dev_model"));
				data.put("excel_column_val2", map.get("self_num"));
				data.put("excel_column_val3", map.get("actual_in_time") + "--"
						+ map.get("actual_out_time"));
				data.put("excel_column_val4",
						map.get("country") + "/" + map.get("project_address"));
				data.put("excel_column_val5", map.get("project_name"));
				data.put("excel_column_val6", map.get("org_abbreviation"));
				data.put("excel_column_val7", map.get("construction_method"));
				data.put("excel_column_val8", map.get("construction_paramete"));
				data.put("excel_column_val9", map.get("surface"));
				data.put("excel_column_val10", map.get("work_hour"));
				data.put("excel_column_val11", map.get("projecter"));

				datas.add(data);
			}
			String name = "�ɿ���Դʩ������";
			String excelName = "�ɿ���Դʩ������.xls";
			List<String> headerList = new ArrayList<String>();

			headerList.add("���");
			headerList.add("�豸�ͺ�");
			headerList.add("�Ա��");
			headerList.add("��ֹʱ��");
			headerList.add("����/����");
			headerList.add("��Ŀ����");
			headerList.add("ʩ���Ӻ�");
			headerList.add("ʩ������");
			headerList.add("ʩ������");
			headerList.add("�ر�����");
			headerList.add("����ʱ��12h/24h");
			headerList.add("��Ŀ��/�鳤");

			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}
		if ("byjl".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");

			String querySql = " select * from (select wx.create_date, wx.bywx_date,wx.maintenance_level, wx.maintenance_desc,(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id, '������Ŀ' as project_name, t.dev_name, t.self_num ,t.dev_model,wx.work_hours, ( case wx.performance_desc    when '0' then '����'  when '1'  then '����'  when '2'  then '����' end )  as performance_desc ,wx.repair_men,wx.bak  from gms_device_zy_bywx wx ";
			querySql += " left join gms_device_account t on wx.dev_acc_id=t.dev_acc_id      where wx.MAINTENANCE_LEVEL <> '��'  and wx.bsflag = '0'  and wx.project_info_id is null ";
			querySql += " and wx.dev_acc_id='"
					+ dev_acc_id
					+ "'   union all      select  wx.create_date, wx.bywx_date,wx.maintenance_level, wx.maintenance_desc, (select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id,   p.project_name ,";
			querySql += " dui.dev_name,   dui.self_num ,dui.dev_model,wx.work_hours, ( case wx.performance_desc    when '0' then '����'  when '1'  then '����'  when '2'  then '����' end )  as performance_desc ,wx.repair_men,wx.bak  from gms_device_zy_bywx wx left join gms_device_account_dui dui on wx.dev_acc_id=dui.dev_acc_id ";
			querySql += " left join gp_task_project p on p.project_info_no=wx.project_info_id  where wx.MAINTENANCE_LEVEL <> '��'  and wx.bsflag = '0'  and wx.project_info_id is not null  and dui.fk_dev_acc_id='"
					+ dev_acc_id
					+ "') tt order by  tt.create_date desc , tt.bywx_date desc ";
			List<Map> mapList = jdbcDao.queryRecords(querySql);

			for (int i = 0; i < mapList.size(); i++) {
				Map map = mapList.get(i);
				Map data = new HashMap();

				data.put("excel_column_val0", map.get("bywx_date"));
				data.put("excel_column_val1", map.get("dev_model"));
				data.put("excel_column_val2", map.get("self_num"));
				data.put("excel_column_val3", map.get("work_hours"));
				data.put("excel_column_val4", map.get("maintenance_level"));
				data.put("excel_column_val5", map.get("maintenance_desc"));
				data.put("excel_column_val6", map.get("performance_desc"));
				data.put("excel_column_val7", map.get("repair_men"));
				data.put("excel_column_val8", map.get("bak"));

				datas.add(data);
			}
			String name = "�ɿ���Դ������¼";
			String excelName = "�ɿ���Դ������¼.xls";
			List<String> headerList = new ArrayList<String>();

			headerList.add("����");
			headerList.add("�豸�ͺ�");
			headerList.add("�Ա��");
			headerList.add("�ۼƹ���Сʱ");
			headerList.add("��������");
			headerList.add("��Ҫ��������");
			headerList.add("��������");
			headerList.add("���ޣ���еʦ��");
			headerList.add("��ע");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}

		if ("byjldui".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");

			String querySql = " select * from (    select  wx.create_date,   wx.bywx_date,wx.maintenance_level, wx.maintenance_desc, (select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id,   p.project_name ,";
			querySql += " dui.dev_name,   dui.self_num ,dui.dev_model,wx.work_hours, ( case wx.performance_desc    when '0' then '����'  when '1'  then '����'  when '2'  then '����' end )  as performance_desc ,wx.repair_men,wx.bak  from gms_device_zy_bywx wx left join gms_device_account_dui dui on wx.dev_acc_id=dui.dev_acc_id ";
			querySql += " left join gp_task_project p on p.project_info_no=wx.project_info_id  where wx.MAINTENANCE_LEVEL <> '��'  and wx.bsflag = '0'  and wx.project_info_id is not null  and dui.dev_acc_id='"
					+ dev_acc_id
					+ "') tt order by  tt.create_date desc , tt.bywx_date desc ";
			List<Map> mapList = jdbcDao.queryRecords(querySql);

			for (int i = 0; i < mapList.size(); i++) {
				Map map = mapList.get(i);
				Map data = new HashMap();

				data.put("excel_column_val0", map.get("bywx_date"));
				data.put("excel_column_val1", map.get("dev_model"));
				data.put("excel_column_val2", map.get("self_num"));
				data.put("excel_column_val3", map.get("work_hours"));
				data.put("excel_column_val4", map.get("maintenance_level"));
				data.put("excel_column_val5", map.get("maintenance_desc"));
				data.put("excel_column_val6", map.get("performance_desc"));
				data.put("excel_column_val7", map.get("repair_men"));
				data.put("excel_column_val8", map.get("bak"));

				datas.add(data);
			}
			String name = "�ɿ���Դ������¼";
			String excelName = "�ɿ���Դ������¼.xls";
			List<String> headerList = new ArrayList<String>();

			headerList.add("����");
			headerList.add("�豸�ͺ�");
			headerList.add("�Ա��");
			headerList.add("�ۼƹ���Сʱ");
			headerList.add("��������");
			headerList.add("��Ҫ��������");
			headerList.add("��������");
			headerList.add("���ޣ���еʦ��");
			headerList.add("��ע");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}

		if ("wxjl".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");

			String sql = "select *  "
					+ " from (select wx.create_date, wx.bak,  wx.legacy, wx.falut_reason, wx.work_hours, t.dev_model, wx.bywx_date, wx.falut_desc,wx.falut_case, wx.maintenance_desc, wx.repair_unit,wx.repair_men, "
					+ "      (select d.coding_name from comm_coding_sort_detail d  where d.coding_code_id = wx.zcj_type) as zcj_type, "
					+ "       wx.usemat_id,t.dev_name, i.wz_name,"
					+ "       t.self_num  from gms_device_zy_bywx wx"
					+ "    left join gms_device_zy_wxbymat w"
					+ "      on wx.usemat_id = w.usemat_id"
					+ "     left join gms_mat_recyclemat_info r "
					+ "     on r.wz_id=w.wz_id"
					+ "     left join gms_mat_infomation  i"
					+ "     on r.wz_id=i.wz_id"
					+ "     left join gms_device_account_dui t"
					+ "     on  t.dev_acc_id=wx.dev_acc_id"
					+ "     where r.wz_type='3' and r.bsflag='0'"
					+ "     and  wx.bsflag='0'"
					+ "     and wx.project_info_id  is not null  and r.project_info_id is not null  and wx.project_info_id=wx.project_info_id "
					+ "      and wx.maintenance_level='��'"
					+ "  and t.fk_dev_acc_id = '"
					+ dev_acc_id
					+ "' "
					+ " union all "
					+ " select wx.create_date, wx.bak,  wx.legacy, wx.falut_reason, wx.work_hours, t.dev_model, wx.bywx_date, wx.falut_desc,wx.falut_case, wx.maintenance_desc, wx.repair_unit,wx.repair_men, "
					+ "      (select d.coding_name from comm_coding_sort_detail d  where d.coding_code_id = wx.zcj_type) as zcj_type, "
					+ "       wx.usemat_id,t.dev_name,i.wz_name, "
					+ "       t.self_num  from gms_device_zy_bywx wx"
					+ "    left join gms_device_zy_wxbymat w"
					+ "      on wx.usemat_id = w.usemat_id"
					+ "     left join gms_mat_recyclemat_info r "
					+ "     on r.wz_id=w.wz_id"
					+ "     left join gms_mat_infomation  i"
					+ "     on i.wz_id=r.wz_id"
					+ "     left join gms_device_account  t"
					+ "     on  t.dev_acc_id=wx.dev_acc_id"
					+ "     where r.wz_type='3' and r.bsflag='0'"
					+ "     and  wx.bsflag='0'"
					+ "     and wx.project_info_id  is  null   and r.project_info_id is  null"
					+ "      and wx.maintenance_level='��'"
					+ "   and t.dev_acc_id = '"
					+ dev_acc_id
					+ "') tt "
					+ " order by tt.bywx_date desc";

			String sql1 = "select *    from (select wx.create_date, wx.bak,"
					+ "    wx.legacy,wx.falut_reason,wx.work_hours,"
					+ "   t.dev_model,wx.bywx_date, wx.falut_desc,"
					+ "  wx.falut_case, wx.maintenance_desc,wx.repair_unit,"
					+ "  wx.repair_men,"
					+ "  (select d.coding_name"
					+ "    from comm_coding_sort_detail d"
					+ "    where d.coding_code_id = wx.zcj_type) as zcj_type,"
					+ "   wx.usemat_id,t.dev_name, '' as  wz_name, t.self_num"
					+ "  from gms_device_zy_bywx wx"
					+ "  left join gms_device_account_dui t"
					+ "    on t.dev_acc_id = wx.dev_acc_id"
					+ "   where "
					+ "    (wx.usemat_id is null   or wx.usemat_id not in (select usemat_id  from gms_device_zy_wxbymat where usemat_id is not null ))"
					+ "    and  wx.bsflag = '0'"
					+ "    and wx.project_info_id is not null "
					+ "    and wx.maintenance_level = '��'"
					+ "    and t.fk_dev_acc_id = '"
					+ dev_acc_id
					+ "'"
					+ "  union all"
					+ "   select  wx.create_date, wx.bak,wx.legacy, wx.falut_reason,wx.work_hours,t.dev_model,wx.bywx_date,wx.falut_desc,"
					+ "       wx.falut_case, wx.maintenance_desc, wx.repair_unit,wx.repair_men,"
					+ "      (select d.coding_name"
					+ "          from comm_coding_sort_detail d"
					+ "        where d.coding_code_id = wx.zcj_type) as zcj_type,"
					+ "       wx.usemat_id,t.dev_name,'' as  wz_name,t.self_num"
					+ "  from gms_device_zy_bywx wx"
					+ "   left join gms_device_account t"
					+ "    on t.dev_acc_id = wx.dev_acc_id"
					+ "  where "
					+ "    ( wx.usemat_id is null  or wx.usemat_id not in (select usemat_id  from gms_device_zy_wxbymat where usemat_id is not null ))"
					+ "   and  wx.bsflag = '0'"
					+ "   and wx.project_info_id is null"
					+ "   and wx.maintenance_level = '��'"
					+ "   and t.dev_acc_id = '" + dev_acc_id + "') tt"
					+ " order by tt.create_date  desc ,tt.bywx_date desc";

			List<Map> mapList = jdbcDao.queryRecords(sql);
			List<Map> mapList2 = jdbcDao.queryRecords(sql1);
			mapList.addAll(mapList2);
			for (int i = 0; i < mapList.size(); i++) {
				Map map = mapList.get(i);
				Map data = new HashMap();
				data.put("excel_column_val0", map.get("bywx_date"));
				data.put("excel_column_val1", map.get("dev_model"));
				data.put("excel_column_val2", map.get("self_num"));
				data.put("excel_column_val3", map.get("work_hours"));
				data.put("excel_column_val4", map.get("falut_desc"));
				data.put("excel_column_val5", map.get("falut_reason"));
				data.put("excel_column_val6", map.get("falut_case"));
				data.put("excel_column_val7", map.get("wz_name"));
				data.put("excel_column_val8", map.get("legacy"));
				data.put("excel_column_val9", map.get("repair_men"));
				data.put("excel_column_val10", map.get("bak"));
				datas.add(data);
			}
			String name = "�ɿ���Դά�޼�¼";
			String excelName = "�ɿ���Դά�޼�¼.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("����");
			headerList.add("�豸�ͺ�");
			headerList.add("�Ա��");
			headerList.add("�ۼƹ���Сʱ");
			headerList.add("��������");
			headerList.add("����ԭ��");
			headerList.add("���Ͻ���취");
			headerList.add("������Ҫ����");
			headerList.add("��������");
			headerList.add("���ޣ���еʦ��");
			headerList.add("��ע");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}
		if ("wxjldui".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String dev_acc_id = msg.getValue("dev_acc_id");

			String sql = "select *  "
					+ " from (select  wx.create_date, wx.bak,  wx.legacy, wx.falut_reason, wx.work_hours, t.dev_model, wx.bywx_date, wx.falut_desc,wx.falut_case, wx.maintenance_desc, wx.repair_unit,wx.repair_men, "
					+ "      (select d.coding_name from comm_coding_sort_detail d  where d.coding_code_id = wx.zcj_type) as zcj_type, "
					+ "       wx.usemat_id,t.dev_name, i.wz_name,"
					+ "       t.self_num  from gms_device_zy_bywx wx"
					+ "    left join gms_device_zy_wxbymat w"
					+ "      on wx.usemat_id = w.usemat_id"
					+ "     left join gms_mat_recyclemat_info r "
					+ "     on r.wz_id=w.wz_id"
					+ "     left join gms_mat_infomation  i"
					+ "     on r.wz_id=i.wz_id"
					+ "     left join gms_device_account_dui t"
					+ "     on  t.dev_acc_id=wx.dev_acc_id"
					+ "     where r.wz_type='3' and r.bsflag='0'"
					+ "     and  wx.bsflag='0'"
					+ "     and wx.project_info_id  is not null  and r.project_info_id is not null  and wx.project_info_id=wx.project_info_id "
					+ "      and wx.maintenance_level='��'"
					+ "  and t.dev_acc_id = '" + dev_acc_id + "' " + ") tt "
					+ " order by tt.bywx_date desc";

			String sql1 = "select *    from (select wx.create_date, wx.bak,"
					+ "    wx.legacy,wx.falut_reason,wx.work_hours,"
					+ "   t.dev_model,wx.bywx_date, wx.falut_desc,"
					+ "  wx.falut_case, wx.maintenance_desc,wx.repair_unit,"
					+ "  wx.repair_men,"
					+ "  (select d.coding_name"
					+ "    from comm_coding_sort_detail d"
					+ "    where d.coding_code_id = wx.zcj_type) as zcj_type,"
					+ "   wx.usemat_id,t.dev_name, '' as  wz_name, t.self_num"
					+ "  from gms_device_zy_bywx wx"
					+ "  left join gms_device_account_dui t"
					+ "    on t.dev_acc_id = wx.dev_acc_id"
					+ "   where "
					+ "    (wx.usemat_id is null   or wx.usemat_id not in (select usemat_id  from gms_device_zy_wxbymat where usemat_id is not null ))"
					+ "    and  wx.bsflag = '0'"
					+ "    and wx.project_info_id is not null "
					+ "    and wx.maintenance_level = '��'"
					+ "    and t.dev_acc_id = '" + dev_acc_id + "'" + " ) tt"
					+ " order by tt.create_date desc ,tt.bywx_date desc";

			List<Map> mapList = jdbcDao.queryRecords(sql);
			List<Map> mapList2 = jdbcDao.queryRecords(sql1);
			mapList.addAll(mapList2);
			for (int i = 0; i < mapList.size(); i++) {
				Map map = mapList.get(i);
				Map data = new HashMap();
				data.put("excel_column_val0", map.get("bywx_date"));
				data.put("excel_column_val1", map.get("dev_model"));
				data.put("excel_column_val2", map.get("self_num"));
				data.put("excel_column_val3", map.get("work_hours"));
				data.put("excel_column_val4", map.get("falut_desc"));
				data.put("excel_column_val5", map.get("falut_reason"));
				data.put("excel_column_val6", map.get("falut_case"));
				data.put("excel_column_val7", map.get("wz_name"));
				data.put("excel_column_val8", map.get("legacy"));
				data.put("excel_column_val9", map.get("repair_men"));
				data.put("excel_column_val10", map.get("bak"));
				datas.add(data);
			}
			String name = "�ɿ���Դά�޼�¼";
			String excelName = "�ɿ���Դά�޼�¼.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("����");
			headerList.add("�豸�ͺ�");
			headerList.add("�Ա��");
			headerList.add("�ۼƹ���Сʱ");
			headerList.add("��������");
			headerList.add("����ԭ��");
			headerList.add("���Ͻ���취");
			headerList.add("������Ҫ����");
			headerList.add("��������");
			headerList.add("���ޣ���еʦ��");
			headerList.add("��ע");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}
		if ("pzybjuse".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String project_info_id = msg.getValue("project_info_id");
			String type = msg.getValue("type");
			String innerIds = "";
			if (null != project_info_id && !"".equals(project_info_id)
					&& !"null".equals(project_info_id)) {
				project_info_id = project_info_id.substring(0,
						project_info_id.lastIndexOf(","));
				String[] ids = project_info_id.split(",");

				for (int i = 0; i < ids.length; i++) {
					innerIds += "'" + ids[i] + "' ,";
				}
				innerIds = innerIds.substring(0, innerIds.lastIndexOf(","));
			}
			String coding_code_id = msg.getValue("coding_code_id");
			String devSql = "";

			String self_num = msg.getValue("type");
			String start_date = msg.getValue("start_date");
			String end_date = msg.getValue("end_date");
			String baseTable = "";
			String baseTable1 = "";
			String sqlTable = "";
			if (null != project_info_id && (!"".equals(project_info_id))) {
				baseTable = "("
						+ "select m.use_num,"
						+ "m.coding_code_id,"
						+ " "
						+ " r.actual_price,"
						+ "  i.wz_name,"
						+ "  m.wz_id"
						+ "      from gms_device_zy_wxbymat m"
						+ " left join gms_device_zy_bywx x"
						+ "  on m.usemat_id = x.usemat_id"
						+ "   left join gms_mat_recyclemat_info r"
						+ "   on m.wz_id = r.wz_id"
						+ " left join gms_mat_infomation i"
						+ "   on r.wz_id = i.wz_id"
						+ " where  x.bsflag='0' and   r.wz_type = '3' and x.project_info_id=r.project_info_id  and  r.project_info_id  is not null "
						+ "  and r.bsflag = '0'"
						+ "  and x.project_info_id in (" + innerIds + ")"
						+ " and m.coding_code_id = '" + coding_code_id + "'";
				if (null != start_date && (!"".equals(start_date))) {
					baseTable += "   and  x.bywx_date>=to_date('" + start_date
							+ "','yyyy-mm-dd')";
				}
				if (null != end_date && (!"".equals(end_date))) {
					baseTable += "   and  x.bywx_date<=to_date('" + end_date
							+ "','yyyy-mm-dd')";
				}
				baseTable += ") a";
				sqlTable = baseTable;
			} else {
				baseTable = "select m.use_num,"
						+ "   m.coding_code_id,"
						+ " "
						+ "    r.actual_price,"
						+ "     i.wz_name,"
						+ "     m.wz_id"
						+ "  from gms_device_zy_wxbymat m"
						+ "  left join gms_device_zy_bywx x"
						+ "    on m.usemat_id = x.usemat_id"
						+ "   left join gms_mat_recyclemat_info r"
						+ "    on m.wz_id = r.wz_id"
						+ "   left join gms_mat_infomation i"
						+ "    on r.wz_id = i.wz_id"
						+ " where x.bsflag='0'  and  r.wz_type = '3' and r.project_info_id is null "
						+ "  and   x.project_info_id is null  and  r.bsflag = '0'"
						+ "   and m.coding_code_id = '" + coding_code_id + "' ";
				if (null != start_date && (!"".equals(start_date))) {
					baseTable += "   and  x.bywx_date>=to_date('" + start_date
							+ "','yyyy-mm-dd')";
				}
				if (null != end_date && (!"".equals(end_date))) {
					baseTable += "   and  x.bywx_date<=to_date('" + end_date
							+ "','yyyy-mm-dd')";
				}
				baseTable += "";

				baseTable1 = "select m.use_num,"
						+ "m.coding_code_id,"
						+ " "
						+ " r.actual_price,"
						+ "  i.wz_name,"
						+ "  m.wz_id"
						+ "      from gms_device_zy_wxbymat m"
						+ " left join gms_device_zy_bywx x"
						+ "  on m.usemat_id = x.usemat_id"
						+ "   left join gms_mat_recyclemat_info r"
						+ "   on m.wz_id = r.wz_id"
						+ " left join gms_mat_infomation i"
						+ "   on r.wz_id = i.wz_id"
						+ " where  x.bsflag='0' and   r.wz_type = '3' and r.project_info_id=x.project_info_id  and  r.project_info_id  is not null and x.project_info_id is not null  "
						+ "  and r.bsflag = '0'" + " and m.coding_code_id = '"
						+ coding_code_id + "'";
				if (null != start_date && (!"".equals(start_date))) {
					baseTable1 += "   and  x.bywx_date>=to_date('" + start_date
							+ "','yyyy-mm-dd')";
				}
				if (null != end_date && (!"".equals(end_date))) {
					baseTable1 += "   and  x.bywx_date<=to_date('" + end_date
							+ "','yyyy-mm-dd')";
				}
				baseTable1 += "";
				sqlTable = "(  select  *   from (" + baseTable
						+ "  union all  " + baseTable1 + ")  k ) kk";
			}

			List<String> equipmentList = new ArrayList<String>();

			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			String nameSql_x = "select distinct wz_id,wz_name  from  "
					+ sqlTable;

			List<Map> listMap = dao.queryRecords(nameSql_x);
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				String element = map.get("wz_id").toString() + "~"
						+ map.get("wz_name");
				equipmentList.add(element);

			}
			String preSql = "";
			if ("num".equals(type)) {
				preSql = "select sum(use_num)  as realnum  from   " + sqlTable
						+ "   where  wz_id='@' " + "   group by wz_id  ";
			} else if ("money".equals(type)) {
				preSql = "select sum(use_num*actual_price)  as realnum  from   "
						+ sqlTable
						+ "   where  wz_id='@' "
						+ "   group by wz_id ";
			}
			for (int i = 0; i < equipmentList.size(); i++) {
				String value = (String) equipmentList.get(i);
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map data = new HashMap();
					data.put("excel_column_val0", equipmentName);
					data.put("excel_column_val1", resultMap.get("realnum"));
					datas.add(data);
				}
			}
			String name = this.getProjectName(project_info_id, "��Դ����������ϸ");
			String excelName = "��Դ������������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			if ("num".equals(type)) {
				excelName = "��Դ������������ͳ��.xls";
				headerList.add("��������");
				headerList.add("��������");
			} else if ("money".equals(type)) {
				excelName = "��Դ�������Ľ��ͳ��.xls";
				headerList.add("��������");
				headerList.add("�����");
			}

			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}

		if ("zybjuse".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String project_info_id = msg.getValue("project_info_id");
			String innerIds = "";
			if (null != project_info_id && !"".equals(project_info_id)
					&& !"null".equals(project_info_id)) {
				project_info_id = project_info_id.substring(0,
						project_info_id.lastIndexOf(","));
				String[] ids = project_info_id.split(",");

				for (int i = 0; i < ids.length; i++) {
					innerIds += "'" + ids[i] + "' ,";
				}
				innerIds = innerIds.substring(0, innerIds.lastIndexOf(","));
			}

			String start_date = msg.getValue("startDate");
			String end_date = msg.getValue("endDate");
			end_date = end_date.substring(0, end_date.lastIndexOf("+"));
			String type = msg.getValue("type");
			List<String> equipmentList = new ArrayList<String>();

			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			List<Map> listMap = dao
					.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				String element = map.get("coding_code_id").toString() + "~"
						+ map.get("coding_name");
				equipmentList.add(element);

			}
			String preSql = "";
			String preSql1 = "";
			String sql = "";
			if ("num".equals(type)) {
				String a = " select sum(realnum) as realnum , coding_code_id"
						+ "  from (select (m.use_num) as realnum, coding_code_id"
						+ "   from gms_device_zy_wxbymat m  left  join gms_mat_recyclemat_info r on m.wz_id=r.wz_id"
						+ "  where   r.wz_type='3'  and r.bsflag='0' and  r.project_info_id is not null   and   m.usemat_id in"
						+ "  (select x. usemat_id  from gms_device_zy_bywx x"
						+ "     where 1=1  and x.bsflag='0'  and x.project_info_id=r.project_info_id   and  x.project_info_id is not null ";
				if (null != project_info_id && !"".equals(project_info_id)
						&& !"null".equals(project_info_id)) {
					a += "   and   x.project_info_id   in (" + innerIds + ") ";
				}

				if (!"".equals(start_date) && null != start_date) {
					a += "    and x.bywx_date>=to_date('" + start_date
							+ "','yyyy-mm-dd')";
				}
				if (!"".equals(end_date) && null != end_date) {
					a += "    and x.bywx_date<=to_date('" + end_date
							+ "','yyyy-mm-dd')";
				}
				String b = ")" + "   and m.coding_code_id = '@'" + "   ) a"
						+ " group by coding_code_id";
				preSql = a + b;

				String a1 = " select sum(realnum) as realnum , coding_code_id"
						+ "  from (select (m.use_num) as realnum, coding_code_id"
						+ "   from gms_device_zy_wxbymat m  left  join gms_mat_recyclemat_info r on m.wz_id=r.wz_id"
						+ "  where   r.wz_type='3'  and r.bsflag='0' and  r.project_info_id is  null    and   m.usemat_id in"
						+ "  (select x. usemat_id  from gms_device_zy_bywx x"
						+ "     where 1=1    and x.project_info_id is  null  and x.bsflag='0'   ";
				if (null != project_info_id && !"".equals(project_info_id)
						&& !"null".equals(project_info_id)) {
					a1 += "   and   x.project_info_id   in (" + innerIds + ") ";
				}

				if (!"".equals(start_date) && null != start_date) {
					a1 += "    and x.bywx_date>=to_date('" + start_date
							+ "','yyyy-mm-dd')";
				}
				if (!"".equals(end_date) && null != end_date) {
					a1 += "    and x.bywx_date<=to_date('" + end_date
							+ "','yyyy-mm-dd')";
				}
				String b1 = ")" + "   and m.coding_code_id = '@'" + "   ) a1"
						+ " group by coding_code_id";
				preSql1 = a1 + b1;

				sql = "select sum(realnum) as realnum , coding_code_id  from  "
						+ "(" + preSql + "   union  all " + preSql1
						+ ") k  group by coding_code_id ";
			} else if ("money".equals(type)) {
				String a = " select sum(realnum) as realnum , coding_code_id"
						+ "  from (select (m.use_num*r.actual_price) as realnum, coding_code_id"
						+ "   from gms_device_zy_wxbymat m,gms_mat_recyclemat_info r "
						+ "  where   m.usemat_id in"
						+ "  (select x. usemat_id  from gms_device_zy_bywx x"
						+ "     where 1=1   and  x.project_info_id=r.project_info_id   and  x.project_info_id is not null  ";
				if (null != project_info_id && !"".equals(project_info_id)
						&& !"null".equals(project_info_id)) {
					a += "  and  x.project_info_id   in (" + innerIds + ") ";
				}

				if (!"".equals(start_date) && null != start_date) {
					a += "    and x.bywx_date>=to_date('" + start_date
							+ "','yyyy-mm-dd')";
				}
				if (!"".equals(end_date) && null != end_date) {
					a += "    and x.bywx_date<=to_date('" + end_date
							+ "','yyyy-mm-dd')";
				}
				String b = ")"
						+ "   and m.coding_code_id = '@'"
						+ "   and  r.wz_type='3' and r.bsflag='0' and r.project_info_id is not null    and r.wz_id=m.wz_id ) a"
						+ " group by coding_code_id";

				String a1 = " select sum(realnum) as realnum , coding_code_id"
						+ "  from (select (m.use_num*r.actual_price) as realnum, coding_code_id"
						+ "   from gms_device_zy_wxbymat m,gms_mat_recyclemat_info r "
						+ "  where   m.usemat_id in"
						+ "  (select x. usemat_id  from gms_device_zy_bywx x"
						+ "     where 1=1    and x.project_info_id is null ";
				if (null != project_info_id && !"".equals(project_info_id)
						&& !"null".equals(project_info_id)) {
					a1 += "  and  x.project_info_id   in (" + innerIds + ") ";
				}

				if (!"".equals(start_date) && null != start_date) {
					a1 += "    and x.bywx_date>=to_date('" + start_date
							+ "','yyyy-mm-dd')";
				}
				if (!"".equals(end_date) && null != end_date) {
					a1 += "    and x.bywx_date<=to_date('" + end_date
							+ "','yyyy-mm-dd')";
				}
				String b1 = ")"
						+ "   and m.coding_code_id = '@'"
						+ "   and  r.wz_type='3' and r.bsflag='0' and r.project_info_id is  null    and r.wz_id=m.wz_id ) a1"
						+ " group by coding_code_id";
				preSql = a + b;
				preSql1 = a1 + b1;

				sql = "select sum(realnum) as realnum , coding_code_id  from  "
						+ "(" + preSql + "   union  all " + preSql1
						+ ") k  group by coding_code_id ";
			}
			// ִ��Sql

			for (int i = 0; i < equipmentList.size(); i++) {
				String value = (String) equipmentList.get(i);
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(sql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map data = new HashMap();
					data.put("excel_column_val0", equipmentName);
					data.put("excel_column_val1", resultMap.get("realnum"));
					datas.add(data);
				}

			}

			String name = this.getProjectName(project_info_id, "��Դ����������ϸ");
			String excelName = "��Դ������������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			if ("num".equals(type)) {
				excelName = "��Դ������������ͳ��.xls";
				headerList.add("��������");
				headerList.add("��������");
			} else if ("money".equals(type)) {
				excelName = "��Դ�������Ľ��ͳ��.xls";
				headerList.add("��������");
				headerList.add("�����");
			}

			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}

		if ("bjxhlsmx".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String wz_id = msg.getValue("wz_id");
			IPureJdbcDao wzjdbc = BeanFactory.getPureJdbcDAO();
			String wz_name = wzjdbc
					.queryRecordBySQL(
							"select  distinct   wz_name from   gms_mat_recyclemat_info r ,    gms_mat_infomation  m where   r.wz_id=m.wz_id  and  r.wz_type='3' and r.bsflag='0' and  r.wz_id='"
									+ wz_id + "'").get("wz_name").toString();
			String coding_code_id = msg.getValue("coding_code_id");
			String self_num = msg.getValue("self_num");
			String project_info_id = msg.getValue("project_info_id");
			String searchSql = "";
			if (null == self_num || "".equals(self_num)
					|| "null".equals(self_num)) {
				searchSql = "select '"
						+ wz_name
						+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price, self_num"
						+ "      from gms_device_zy_bywx      x,"
						+ "      gms_device_zy_wxbymat   w,"
						+ "       gms_mat_recyclemat_info i,"
						+ "gms_device_account_dui  d"
						+ "       where x.dev_acc_id in (select t.dev_acc_id"
						+ "                   from gms_device_account_dui t"
						+ "                 )"
						+ "       and x.usemat_id = w.usemat_id"
						+ "       and w.wz_id = '"
						+ wz_id
						+ "'"
						+ "       and w.coding_code_id = '"
						+ coding_code_id
						+ "'"
						+ "       and i.wz_id = w.wz_id  and i.wz_type='3' and    i.project_info_id=x.project_info_id  and  i.project_info_id is not null   and i.bsflag = '0'"
						+ "       and    x.project_info_id='" + project_info_id
						+ "'" + "    and  d.dev_acc_id=x.dev_acc_id";

			} else {

				searchSql = "select '"
						+ wz_name
						+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price  ,self_num"
						+ "      from gms_device_zy_bywx      x,"
						+ "      gms_device_zy_wxbymat   w,"
						+ "       gms_mat_recyclemat_info i,"
						+ "     gms_device_account_dui d"
						+ "       where x.dev_acc_id in (select t.dev_acc_id"
						+ "                   from gms_device_account_dui t"
						+ "                 where t.self_num = '"
						+ self_num
						+ "')"
						+ "       and x.usemat_id = w.usemat_id"
						+ "       and w.wz_id = '"
						+ wz_id
						+ "'"
						+ "       and w.coding_code_id = '"
						+ coding_code_id
						+ "'"
						+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and  i.project_info_id is not null   and i.bsflag = '0'"
						+ "   and    x.project_info_id='" + project_info_id
						+ "'" + "   and d.dev_acc_id=x.dev_acc_id";
			}

			// ִ��Sql
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			List<Map> resultList = null;
			try {
				resultList = jdbcDAO.queryRecords(searchSql);
			} catch (Exception e) {
				// message.append("�������ѯ�����ֶβ�����!");
			}
			// ��ȡ���
			String equipmentNum = "";
			// ƴXML�ĵ�
			if (resultList != null) {
				for (int i = 0; i < resultList.size(); i++) {
					Map tempMap = resultList.get(i);
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", tempMap.get("self_num")
							.toString());
					data.put("excel_column_val1", tempMap.get("wz_name")
							.toString());
					data.put("excel_column_val2", tempMap.get("actual_price")
							.toString());
					data.put("excel_column_val3", tempMap.get("use_num")
							.toString());
					data.put("excel_column_val4", tempMap.get("price")
							.toString());
					data.put("excel_column_val5", tempMap.get("bywx_date")
							.toString());

					datas.add(data);
				}
			}
			String name = this.getProjectName(project_info_id, "��������������ʷ��ϸ");
			String excelName = "��������������ʷ��ϸͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Դ���");
			headerList.add("��������");
			headerList.add("����");
			headerList.add("��������");
			headerList.add("���Ľ��");
			headerList.add("��������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}

		if ("dxmbjxhcc".equals(exportFlag)) {
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			String project_info_id = msg.getValue("project_info_id");
			String coding_code_id = msg.getValue("coding_code_id");
			String devSql = "";

			String self_num = msg.getValue("self_num");
			String start_date = msg.getValue("start_date");
			String end_date = msg.getValue("end_date");
			// ˧ѡ������������Ŀ
			String selectProjectSql = "select t.project_info_no"
					+ "     from    gp_task_project t, gp_task_project_dynamic t2"
					+ "     where t.project_info_no = t2.project_info_no and t.bsflag='0'";
			if (null != project_info_id && (!"".equals(project_info_id))) {
				selectProjectSql += "     and  t.project_info_no='"
						+ project_info_id + "'";
			}
			if (null != start_date && (!"".equals(start_date))) {
				selectProjectSql += "   and  t.acquire_end_time>=to_date('"
						+ start_date + "','yyyy-mm-dd')";
			}
			if (null != end_date && (!"".equals(end_date))) {
				selectProjectSql += "   and  t.acquire_end_time<=to_date('"
						+ end_date + "','yyyy-mm-dd')";
			}

			if (null != self_num && (!"".equals(self_num))) {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where  d.project_info_id  in ("
						+ selectProjectSql
						+ ")"
						+ "   and  d.self_num ='"
						+ self_num + "'";
			} else {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.project_info_id  in ("
						+ selectProjectSql + ")";
			}

			List<String> equipmentList = new ArrayList<String>();

			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			String nameSql_x = "select distinct m.wz_id,r.wz_name"
					+ " from gms_device_zy_wxbymat m,"
					+ "   gms_mat_infomation r, gms_mat_recyclemat_info mat"
					+ " where mat.wz_type='3'  and   mat .bsflag='0' and  mat.project_info_id  is not null  and   m.usemat_id in"
					+ "     (select t.usemat_id"
					+ "       from gms_device_zy_bywx t"
					+ "      where  t.project_info_id=mat.project_info_id   and t.bsflag='0'  and  t.dev_acc_id in"
					+ "           (select dev_acc_id from gms_device_account_dui))"
					+ "   and m.coding_code_id = '" + coding_code_id + "'"
					+ "  and r.wz_id=m.wz_id   and mat.wz_id=r.wz_id";
			List<Map> listMap = dao.queryRecords(nameSql_x);
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				String element = map.get("wz_id").toString() + "~"
						+ map.get("wz_name");
				equipmentList.add(element);

			}

			String preSql = "select  realnum from ( select m.wz_id, sum(m.use_num) as realnum"
					+ " from gms_device_zy_wxbymat m  left join  gms_mat_recyclemat_info r on m.wz_id=r.wz_id"
					+ "    where  r.wz_type='3'  and r.bsflag='0'  and  r.project_info_id is not null   and  m.usemat_id in"
					+ "      (select t.usemat_id"
					+ "        from gms_device_zy_bywx t"
					+ "     where  t.project_info_id=r.project_info_id   and    t.project_info_id='"
					+ project_info_id
					+ "'  and  t.dev_acc_id in"
					+ "            ("
					+ devSql
					+ "))"
					+ "  and m.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ " group by m.wz_id) a where a.wz_id='@'";

			for (int i = 0; i < equipmentList.size(); i++) {
				String value = (String) equipmentList.get(i);
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map data = new HashMap();
					data.put("excel_column_val0", equipmentName);
					data.put("excel_column_val1", resultMap.get("realnum"));
					datas.add(data);
				}

			}
			String name = this.getProjectName(project_info_id, "��������������ϸ");
			String excelName = "����Ŀ����������ϸ����ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��������");
			headerList.add("��������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}

		if ("lpbjcount".equals(exportFlag)) {
			// &startDate="+startDate+"&endDate="+endDate+"&dev_coding="+dev_coding+"&project_info_id="+project_info_id;
			String project_info_id = msg.getValue("project_info_id");
			String self_num = msg.getValue("dev_coding");
			String startDate = msg.getValue("startDate");
			if (startDate == null || "".equals(startDate)) {
				SimpleDateFormat sf = new SimpleDateFormat("yyyy-mm");
				startDate = sf.format(new Date()) + "-01";
			}
			String endDate = msg.getValue("endDate");
			if (endDate == null || "".equals(endDate)) {
				SimpleDateFormat sf = new SimpleDateFormat("yyyy-mm-dd");
				endDate = sf.format(new Date());
			}
			// �����Ŀ��� in
			String idsSql = "";
			// ˧ѡ�豸
			String devSql = "";
			String bywxSql = "";
			String selectedProjectSql = "select distinct  t.project_info_no,t.project_name"
					+ "    from gp_task_project t, gp_task_project_dynamic t2"
					+ "    where t.project_info_no = t2.project_info_no and t.bsflag='0' ";
			// 1.��״ͼ��������ʾ��Ŀ
			// ��Ŀ���Ϊ����ʾ������Ŀ
			// ��Ŀ��Ų�Ϊ������ʾѡ�����Ŀ����
			// ������Ŀ��LIST
			boolean isfilterDate = true;
			if (null != project_info_id && (!"".equals(project_info_id))) {
				isfilterDate = false;
				String[] ids = project_info_id.split(",");

				for (int i = 0; i < ids.length; i++) {
					idsSql += "'" + ids[i] + "',";
				}
				idsSql = idsSql.substring(0, idsSql.lastIndexOf(","));
				selectedProjectSql += "  and  t.project_info_no in (" + idsSql
						+ ")";
				// ɸѡ��һ��ʱ������������е���Ŀ
				if (null != startDate && (!"".equals(startDate))) {
					selectedProjectSql += "  and  t.acquire_end_time>to_date('"
							+ startDate + "','yyyy-mm-dd') ";
				}

				if (null != endDate && (!"".equals(endDate))) {
					selectedProjectSql += "and t.acquire_end_time<= to_date('"
							+ endDate + "','yyyy-mm-dd')";
				}
			}
			if (isfilterDate) {
				// ɸѡ��һ��ʱ������������е���Ŀ
				if (null != startDate && (!"".equals(startDate))) {
					selectedProjectSql += "  and  t.acquire_end_time>to_date('"
							+ startDate + "','yyyy-mm-dd') ";
				}

				if (null != endDate && (!"".equals(endDate))) {
					selectedProjectSql += "and t.acquire_end_time<= to_date('"
							+ endDate + "','yyyy-mm-dd')";
				}
			}
			List<String> projectList = new ArrayList<String>();
			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			List<Map> listMap = dao.queryRecords(selectedProjectSql);
			if (null != listMap) {
				for (int i = 0; i < listMap.size(); i++) {
					Map map = listMap.get(i);
					Object info_no = map.get("project_info_no");
					Object name = map.get("project_name");
					if (null != info_no && null != name) {
						String id = info_no.toString();
						String project_name = name.toString();
						String element = id + "~" + project_name;
						projectList.add(element);
					}

				}
			}

			// ǰ̨�ֶ�ѡ����Դ���
			if (null != self_num && (!"".equals(self_num))) {
				devSql = "select  d.project_info_id from gms_device_account_dui d where d.self_num = '"
						+ self_num + "'";
			} else {
				devSql = "select  d.project_info_id from gms_device_account_dui d";
			}
			selectedProjectSql += "   and t.project_info_no  in ( " + devSql
					+ ")";

			String preSql = "";
			if (null != self_num && (!"".equals(self_num))) {
				preSql = "  select sum(m.use_num) as  realnum"
						+ "   from gms_device_zy_wxbymat m  left join gms_mat_recyclemat_info  r on m.wz_id=r.wz_id"
						+ "   where   r.wz_type='3'  and r.bsflag='0'  and   r.project_info_id is not null  and   usemat_id in (select usemat_id"
						+ "            from gms_device_zy_bywx t"
						+ "         where   t.project_info_id=r.project_info_id  and t.project_info_id = '@' and t.dev_acc_id in (select dev_acc_id from gms_device_account_dui where self_num='"
						+ self_num + "' ))";
			} else {
				preSql = "  select sum(m.use_num) as  realnum"
						+ "   from gms_device_zy_wxbymat m  left join gms_mat_recyclemat_info  r on m.wz_id=r.wz_id"
						+ "   where    r.wz_type='3'  and r.bsflag='0'   and    r.project_info_id is not null   and    usemat_id in (select usemat_id"
						+ "            from gms_device_zy_bywx t"
						+ "         where t.project_info_id=r.project_info_id  and  t.project_info_id = '@')";
			}
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			for (int i = 0; i < projectList.size(); i++) {
				String value = (String) projectList.get(i);
				String[] strArray = value.split("~");
				String projectCode = strArray[0];
				String projectName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map data = new HashMap();
					data.put("excel_column_val0", projectName);
					if (null == resultMap.get("realnum")) {
						data.put("excel_column_val1", "0");
					} else {
						if ("".equals(resultMap.get("realnum").toString())
								|| null == resultMap.get("realnum").toString()) {
							data.put("excel_column_val1", "0");
						} else {
							data.put("excel_column_val1",
									resultMap.get("realnum"));
						}
					}

					datas.add(data);

				}
			}
			String excelName = "����Ŀ������������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Ŀ����");
			headerList.add("���ı�������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", "����Ŀ������������ͳ��");
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		if ("dxmbjxhmx".equals(exportFlag)) {
			String project_info_id = msg.getValue("project_info_id");
			String coding_code_id = msg.getValue("coding_code_id");
			String devSql = "";
			String name = this.getProjectName(projectInfoNo, "�������Ľ����ϸ");
			String self_num = msg.getValue("self_num");
			String start_date = msg.getValue("start_date");
			String end_date = msg.getValue("end_date");
			// ˧ѡ������������Ŀ
			String selectProjectSql = "select t.project_info_no"
					+ "     from    gp_task_project t, gp_task_project_dynamic t2"
					+ "     where t.project_info_no = t2.project_info_no and t.bsflag='0'";
			if (null != project_info_id && (!"".equals(project_info_id))) {
				selectProjectSql += "     and  t.project_info_no='"
						+ project_info_id + "'";
			}
			if (null != start_date && (!"".equals(start_date))) {
				selectProjectSql += "   and  t.acquire_end_time>=to_date('"
						+ start_date + "','yyyy-mm-dd')";
			}
			if (null != end_date && (!"".equals(end_date))) {
				selectProjectSql += "   and  t.acquire_end_time<=to_date('"
						+ end_date + "','yyyy-mm-dd')";
			}

			if (null != self_num && (!"".equals(self_num))
					&& (!"null".equals(self_num))) {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where  d.project_info_id  in ("
						+ selectProjectSql
						+ ")"
						+ "   and  d.self_num ='"
						+ self_num + "'";
			} else {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.project_info_id  in ("
						+ selectProjectSql + ")";
			}

			List<String> equipmentList = new ArrayList<String>();

			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			String nameSql_x = "select distinct m.wz_id,r.wz_name"
					+ " from gms_device_zy_wxbymat m,"
					+ "   gms_mat_infomation r,gms_mat_recyclemat_info mat "
					+ " where mat.bsflag='0'  and mat.wz_type='3'  and mat.project_info_id is not null   and  m.usemat_id in"
					+ "     (select t.usemat_id"
					+ "       from gms_device_zy_bywx t"
					+ "      where  mat.project_info_id =t.project_info_id   and  t.bsflag='0'   and  t.project_info_id='"
					+ project_info_id
					+ "'   and  t.dev_acc_id in"
					+ "           (select dev_acc_id from gms_device_account_dui)"
					+ "    and  t.project_info_id='" + project_info_id + "')"
					+ "   and m.coding_code_id = '" + coding_code_id + "'"
					+ "  and r.wz_id=m.wz_id";
			List<Map> listMap = dao.queryRecords(nameSql_x);
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				String element = map.get("wz_id").toString() + "~"
						+ map.get("wz_name");
				equipmentList.add(element);

			}

			String preSql = "select  realnum from ( select m.wz_id, sum(m.use_num*r.actual_price) as realnum"
					+ " from gms_device_zy_wxbymat m,"
					+ "   gms_mat_recyclemat_info  r"
					+ " where   r.bsflag='0'  and r.wz_type='3'  and r.project_info_id is not null   and m.usemat_id in"
					+ "      (select t.usemat_id"
					+ "        from gms_device_zy_bywx t"
					+ "     where r.project_info_id =t.project_info_id   and   t.bsflag='0' and   t.dev_acc_id in"
					+ "            ("
					+ devSql
					+ "))"
					+ "  and m.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ " and r.wz_id=m.wz_id and r.wz_type='3' and r.bsflag='0' "
					+ " group by m.wz_id) a where a.wz_id='@'";
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			for (int i = 0; i < equipmentList.size(); i++) {
				String value = (String) equipmentList.get(i);
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {

					Map data = new HashMap();
					data.put("excel_column_val0", equipmentName);
					data.put("excel_column_val1", resultMap.get("realnum"));
					datas.add(data);

				}
			}
			String excelName = "����Ŀ�������Ľ��ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��������");
			headerList.add("���Ľ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", name);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);

		}
		// ����Ŀ�������
		if ("aptm".equals(exportFlag)) {
			String project_info_id = msg.getValue("project_info_id");
			String dev_coding = msg.getValue("dev_coding");
			String startDate = msg.getValue("startDate");
			if (startDate == null || "".equals(startDate)) {
				SimpleDateFormat sf = new SimpleDateFormat("yyyy-mm");
				startDate = sf.format(new Date()) + "-01";
			}
			String endDate = msg.getValue("endDate");
			if (endDate == null || "".equals(endDate)) {
				SimpleDateFormat sf = new SimpleDateFormat("yyyy-mm-dd");
				endDate = sf.format(new Date());
			}
			// �����Ŀ��� in
			String idsSql = "";
			// ˧ѡ�豸
			String devSql = "";
			String bywxSql = "";
			String selectedProjectSql = "select distinct t.project_info_no,t.project_name"
					+ "    from gp_task_project t, gp_task_project_dynamic t2"
					+ "    where t.project_info_no = t2.project_info_no and t.bsflag='0' ";
			// 1.��״ͼ��������ʾ��Ŀ
			// ��Ŀ���Ϊ����ʾ������Ŀ
			// ��Ŀ��Ų�Ϊ������ʾѡ�����Ŀ����
			// ������Ŀ��LIST
			boolean isfilterDate = true;
			if (null != project_info_id && (!"".equals(project_info_id))) {
				isfilterDate = false;
				String[] ids = project_info_id.split(",");

				for (int i = 0; i < ids.length; i++) {
					idsSql += "'" + ids[i] + "',";
				}
				idsSql = idsSql.substring(0, idsSql.lastIndexOf(","));
				selectedProjectSql += "  and  t.project_info_no in (" + idsSql
						+ ")";
				// ɸѡ��һ��ʱ������������е���Ŀ
				if (null != startDate && (!"".equals(startDate))) {
					selectedProjectSql += "  and  t.acquire_end_time>to_date('"
							+ startDate + "','yyyy-mm-dd') ";
				}

				if (null != endDate && (!"".equals(endDate))) {
					selectedProjectSql += "and t.acquire_end_time<= to_date('"
							+ endDate + "','yyyy-mm-dd')";
				}
			}
			if (isfilterDate) {
				// ɸѡ��һ��ʱ������������е���Ŀ
				if (null != startDate && (!"".equals(startDate))) {
					selectedProjectSql += "  and  t.acquire_end_time>to_date('"
							+ startDate + "','yyyy-mm-dd') ";
				}

				if (null != endDate && (!"".equals(endDate))) {
					selectedProjectSql += "and t.acquire_end_time<= to_date('"
							+ endDate + "','yyyy-mm-dd')";
				}
			}
			List<String> projectList = new ArrayList<String>();
			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			List<Map> listMap = dao.queryRecords(selectedProjectSql);
			if (null != listMap) {
				for (int i = 0; i < listMap.size(); i++) {
					Map map = listMap.get(i);
					Object info_no = map.get("project_info_no");
					Object name = map.get("project_name");
					if (null != info_no && null != name) {
						String id = info_no.toString();
						String project_name = name.toString();
						String element = id + "~" + project_name;
						projectList.add(element);
					}

				}
			}

			// ǰ̨�ֶ�ѡ����Դ���
			if (null != dev_coding && (!"".equals(dev_coding))) {
				devSql = "select  d.project_info_id from gms_device_account_dui d where d.self_num = '"
						+ dev_coding + "'";
			} else {
				devSql = "select  d.project_info_id from gms_device_account_dui d";
			}
			selectedProjectSql += "   and t.project_info_no  in ( " + devSql
					+ ")";
			String preSql = "";
			if (null != dev_coding && (!"".equals(dev_coding))) {

				preSql = "   select sum(m.use_num*n.actual_price) as realnum"
						+ "  from gms_device_zy_wxbymat m ,gms_mat_recyclemat_info n"
						+ "  where  n.wz_type='3'  and n.bsflag='0'   and  r.project_info_id  is not null  and  usemat_id in (select usemat_id from gms_device_zy_bywx t where t.project_info_id=n.project_info_id  and  t.project_info_id='@' and t.dev_acc_id   in (select dev_acc_id from gms_device_account_dui  where self_num='"
						+ dev_coding + "' )) and m.wz_id=n.wz_id";
			} else {
				preSql = "   select sum(m.use_num*n.actual_price) as realnum"
						+ "  from gms_device_zy_wxbymat m ,gms_mat_recyclemat_info n"
						+ "  where   n.wz_type='3'  and n.bsflag='0'  and  n.project_info_id is not null   and   usemat_id in (select usemat_id from gms_device_zy_bywx t where  t.project_info_id=n.project_info_id  and   t.project_info_id='@' ) and m.wz_id=n.wz_id";
			}

			List<Map> datas = new ArrayList<Map>();
			for (int i = 0; i < projectList.size(); i++) {
				String value = (String) projectList.get(i);
				String[] strArray = value.split("~");
				String projectCode = strArray[0];
				String projectName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���

				if (resultMap != null) {

					Map data = new HashMap();
					data.put("excel_column_val0", projectName);
					if (null == resultMap.get("realnum")) {
						data.put("excel_column_val1", "0");
					} else {
						if (null == resultMap.get("realnum").toString()
								|| "".equals(resultMap.get("realnum")
										.toString())) {
							data.put("excel_column_val1", "0");
						} else {
							data.put("excel_column_val1",
									resultMap.get("realnum"));
						}
					}

					datas.add(data);

				}
			}
			String excelName = "����Ŀ�������Ľ��ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Ŀ����");
			headerList.add("���Ľ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", "����Ŀ�������Ľ��ͳ��");
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}

		// ��̨�����ۼƹ���Сʱ������ϸ
		if ("whsbjxhmxh".equals(exportFlag)) {
			String wz_id = msg.getValue("wz_id");
			IPureJdbcDao wzjdbc = BeanFactory.getPureJdbcDAO();

			String wz_name = wzjdbc
					.queryRecordBySQL(
							"select distinct  i.wz_name from gms_mat_infomation i ,gms_mat_recyclemat_info r  where r.wz_id=i.wz_id and r.wz_type='3' and r.bsflag='0' and i.wz_id='"
									+ wz_id + "'").get("wz_name").toString();
			String coding_code_id = msg.getValue("coding_code_id");
			String self_num = msg.getValue("self_num");
			String work_hours = msg.getValue("work_hours");
			String work_hours_begin = msg.getValue("work_hours_begin");
			String work_hours_end = msg.getValue("work_hours_end");
			String real_dev_acc_id = msg.getValue("real_dev_acc_id");
			IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
			String projectName = this.getProjectName(projectInfoNo,
					"��̨��Դ���ϲ�������ͳ��");
			String searchSql = "select '"
					+ wz_name
					+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price"
					+ "      from gms_device_zy_bywx      x,"
					+ "      gms_device_zy_wxbymat   w,"
					+ "       gms_mat_recyclemat_info i"
					+ "       where i.project_info_id =x.project_info_id    and  i.project_info_id is not null and  x.project_info_id is not null and  x.project_info_id is not  null  and  i.project_info_id is not null and  x.bsflag='0'  and  x.dev_acc_id in (select t.dev_acc_id"
					+ "                   from gms_device_account_dui t"
					+ "                 where t.self_num = '"
					+ self_num
					+ "')"
					+ "       and x.usemat_id = w.usemat_id"
					+ "       and w.wz_id = '"
					+ wz_id
					+ "'"
					+ "       and w.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.bsflag = '0'";
			if (null != work_hours && (!"".equals(work_hours))) {
				searchSql += " and  x.work_hours='" + work_hours + "'";
			}

			if (null != work_hours_begin && (!"".equals(work_hours_begin))) {
				searchSql += "   and  to_number(x.work_hours)>="
						+ work_hours_begin + "   ";
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))) {
				searchSql += "   and  to_number(x.work_hours)<="
						+ work_hours_end + "   ";
			}

			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			List<Map> resultList = jdbcDAO.queryRecords(searchSql);

			String searchSql1 = "select '"
					+ wz_name
					+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price"
					+ "      from gms_device_zy_bywx      x,"
					+ "      gms_device_zy_wxbymat   w,"
					+ "       gms_mat_recyclemat_info i"
					+ "       where  i.project_info_id is  null and  x.project_info_id is  null and  x.project_info_id is  null  and  i.project_info_id is  null and  x.bsflag='0'  and   x.dev_acc_id in (select t.dev_acc_id"
					+ "                   from     gms_device_account t"
					+ "                 where   t.dev_acc_id='"
					+ real_dev_acc_id
					+ "'  and   t.self_num = '"
					+ self_num
					+ "')"
					+ "       and x.usemat_id = w.usemat_id"
					+ "       and w.wz_id = '"
					+ wz_id
					+ "'"
					+ "       and w.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.bsflag = '0'";
			if (null != work_hours && (!"".equals(work_hours))) {
				searchSql1 += " and  x.work_hours='" + work_hours + "'";
			}

			if (null != work_hours_begin && (!"".equals(work_hours_begin))) {
				searchSql1 += "   and  to_number(x.work_hours)>="
						+ work_hours_begin + "   ";
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))) {
				searchSql1 += "   and  to_number(x.work_hours)<="
						+ work_hours_end + "   ";
			}

			// ִ��Sql
			IPureJdbcDao jdbcDAO1 = BeanFactory.getPureJdbcDAO();
			List<Map> resultList1 = null;
			try {
				resultList1 = jdbcDAO1.queryRecords(searchSql1);
			} catch (Exception e) {
				// message.append("�������ѯ�����ֶβ�����!");
			}

			resultList.addAll(resultList1);
			List<Map> datas = new ArrayList<Map>();
			if (null != resultList) {
				for (int i = 0; i < resultList.size(); i++) {
					Map map = resultList.get(i);
					Map data = new HashMap();
					data.put("excel_column_val0", map.get("wz_name"));
					data.put("excel_column_val1", map.get("actual_price"));
					data.put("excel_column_val2", map.get("use_num"));
					data.put("excel_column_val3", map.get("bywx_date"));
					data.put("excel_column_val4", map.get("price"));
					datas.add(data);
				}
			}
			String excelName = "��̨������ϸ����ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��������");
			headerList.add("����");
			headerList.add("��������");
			headerList.add("��������");
			headerList.add("���Ľ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		// ��̨��Դ�ۼƹ���Сʱ��ĳ�ಿ����ϸ
		if ("dtbjxhmxh".equals(exportFlag)) {
			String self_num = msg.getValue("self_num");
			String coding_code_id = msg.getValue("coding_code_id");
			String work_hours = msg.getValue("work_hours");
			String work_hours_begin = msg.getValue("work_hours_begin");
			String work_hours_end = msg.getValue("work_hours_end");

			IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
			String sqlCodingName = "select  coding_name from comm_coding_sort_detail where coding_sort_id='5110000188' and coding_code_id='"
					+ coding_code_id + "'";
			Map map = jdbc.queryRecordBySQL(sqlCodingName);
			String coding_name = map.get("coding_name").toString();
			String projectName = this.getProjectName(projectInfoNo,
					"��̨��Դ���ϲ�������ͳ��");
			String real_dev_acc_id = msg.getValue("real_dev_acc_id");
			String a = "select wz_id, sum(use_num) as realnum"
					+ " from (select m.wz_id, r.actual_price, m.use_num"
					+ "    from gms_device_zy_wxbymat   m,"
					+ "        gms_mat_recyclemat_info r,"
					+ "            gms_mat_infomation      i"
					+ "      where   m.usemat_id in "
					+ "              (select o.usemat_id"
					+ "                 from gms_device_zy_bywx o"
					+ "                where o.project_info_id =r.project_info_id  and  o.project_info_id is not null and  o.bsflag='0'  and  o.dev_acc_id in"
					+ "                      (select t.dev_acc_id"
					+ "                         from gms_device_account_dui t"
					+ "                         where t.self_num = '"
					+ self_num + "') " + " and m.usemat_id=o.usemat_id";
			if (null != work_hours_begin && (!"".equals(work_hours_begin))) {
				a += "   and  to_number(o.work_hours)>=" + work_hours_begin;
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))) {
				a += "  and   to_number(o.work_hours)<=" + work_hours_end;
			}
			if (null != work_hours && (!"".equals(work_hours))) {
				a += "    and  o.work_hours='" + work_hours + "'";
			}
			a += " )";
			String b = "          and m.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "           and r.wz_id = m.wz_id"
					+ "           and m.wz_id = i.wz_id  and r.wz_type='3'  and r.bsflag = '0' and r.project_info_id is not null ) a  where a.wz_id='@' "
					+ "  group by wz_id";

			String searchSql = a + b;

			String a1 = "select wz_id, sum(use_num) as realnum"
					+ " from (select m.wz_id, r.actual_price, m.use_num"
					+ "    from gms_device_zy_wxbymat   m,"
					+ "        gms_mat_recyclemat_info r,"
					+ "            gms_mat_infomation      i"
					+ "      where m.usemat_id in "
					+ "              (select o.usemat_id"
					+ "                 from gms_device_zy_bywx o"
					+ "                where  o.project_info_id is null  and  o.bsflag='0'  and  o.dev_acc_id in"
					+ "                      (select t.dev_acc_id"
					+ "                         from gms_device_account t"
					+ "                         where   t.dev_acc_id='"
					+ real_dev_acc_id + "' and   t.self_num = '" + self_num
					+ "') " + " and m.usemat_id=o.usemat_id";
			if (null != work_hours_begin && (!"".equals(work_hours_begin))) {
				a1 += "   and  to_number(o.work_hours)>=" + work_hours_begin;
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))) {
				a1 += "  and   to_number(o.work_hours)<=" + work_hours_end;
			}
			if (null != work_hours && (!"".equals(work_hours))) {
				a1 += "    and  o.work_hours='" + work_hours + "'";
			}
			a1 += " )";
			String b1 = "          and m.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "           and r.wz_id = m.wz_id"
					+ "           and m.wz_id = i.wz_id  and r.wz_type='3'  and r.bsflag = '0' and r.project_info_id is null  ) a  where a.wz_id='@' "
					+ "  group by wz_id";

			String searchSql1 = a1 + b1;

			String bigTable = "(" + searchSql + "  union all  " + searchSql1
					+ ")  aa ";
			String doSql = "select sum(realnum)  as realnum  from  " + bigTable
					+ " group by wz_id";

			String x_nameSql = "select distinct wz_id, wz_name"
					+ "    from gms_mat_infomation"
					+ "     where wz_id in("
					+ "          select wz_id"
					+ "             from (select m.wz_id"
					+ "               from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
					+ "              where m.usemat_id in"
					+ "                    (select o.usemat_id"
					+ "                      from gms_device_zy_bywx o"
					+ "                      where   o.project_info_id =r.project_info_id and   o.work_hours='"
					+ work_hours
					+ "' and   o.dev_acc_id in"
					+ "                            (select t.dev_acc_id"
					+ "                              from gms_device_account_dui t"
					+ "                             where t.self_num = '"
					+ self_num + "'))"
					+ "                and m.coding_code_id = '"
					+ coding_code_id + "'"
					+ "                and r.wz_id = m.wz_id ))";

			String x_nameSql1 = "select distinct wz_id, wz_name"
					+ "    from gms_mat_infomation"
					+ "     where wz_id in("
					+ "          select wz_id"
					+ "             from (select m.wz_id"
					+ "               from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
					+ "              where m.usemat_id in"
					+ "                    (select o.usemat_id"
					+ "                      from gms_device_zy_bywx o"
					+ "                      where   o.project_info_id  is null and  o.work_hours='"
					+ work_hours + "' and   o.dev_acc_id in"
					+ "                            (select t.dev_acc_id"
					+ "                              from gms_device_account t"
					+ "                             where   t.dev_acc_id='"
					+ real_dev_acc_id + "' and  t.self_num = '" + self_num
					+ "'))" + "                and m.coding_code_id = '"
					+ coding_code_id + "'"
					+ "                and r.wz_id = m.wz_id ))";

			IPureJdbcDao jdbc2 = BeanFactory.getPureJdbcDAO();
			// �洢������
			List<Map> wzMapList = jdbc2.queryRecords(x_nameSql);

			List<String> wz = new ArrayList<String>();
			for (int i = 0; i < wzMapList.size(); i++) {
				wz.add(wzMapList.get(i).get("wz_id") + "~"
						+ wzMapList.get(i).get("wz_name"));
			}

			IPureJdbcDao jdbc1 = BeanFactory.getPureJdbcDAO();
			// �洢������
			List<Map> wzMapList1 = jdbc.queryRecords(x_nameSql1);
			for (int i = 0; i < wzMapList1.size(); i++) {
				wz.add(wzMapList1.get(i).get("wz_id") + "~"
						+ wzMapList1.get(i).get("wz_name"));
			}
			Set<String> wzList = new HashSet<String>(wz);

			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			Iterator<String> iter = wzList.iterator();
			while (iter.hasNext()) {
				String value = iter.next();
				String[] strArray = value.split("~");
				String wzCode = strArray[0];
				String wzName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(doSql);
				presqli = presqli.replaceAll("@", strArray[0]);
				selectSql.append(presqli);
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", self_num);
					data.put("excel_column_val1", work_hours);
					data.put("excel_column_val2", strArray[1]);
					equipmentNum = resultMap.get("realnum").toString();
					data.put("excel_column_val3", equipmentNum);
					datas.add(data);
				}
			}
			String excelName = "��̨�ۼƹ���Сʱ������ϸ����ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Դ���");
			headerList.add("�ۼƹ���Сʱ");
			headerList.add("��������");
			headerList.add("��������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}

		// ��̨��Դĳһ������ͬ�ۼƹ���Сʱ���ϲ�������ͳ��
		if ("SDFX".equals(exportFlag)) {

			String project_info_id = msg.getValue("project_info_id");
			String self_num = msg.getValue("self_num");
			String work_hours = msg.getValue("work_hours");
			String coding_code_id = msg.getValue("coding_code_id");
			String s_work_hours_max = msg.getValue("s_work_hours_max");
			String real_dev_acc_id = msg.getValue("real_dev_acc_id");

			IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
			String sqlCodingName = "select  coding_name from comm_coding_sort_detail where coding_sort_id='5110000188' and coding_code_id='"
					+ coding_code_id + "'";
			Map map = jdbc.queryRecordBySQL(sqlCodingName);
			String coding_name = map.get("coding_name").toString();
			String projectName = this.getProjectName(projectInfoNo,
					"��̨��Դ���ϲ�������ͳ��");
			String devSql = "";
			String bywxSql = "";
			boolean isAdd = false;
			if (null != self_num && (!"".equals(self_num))) {
				devSql = "select dev_acc_id from gms_device_account_dui t where t.self_num= '"
						+ self_num + "'";
			} else {
				devSql = "select dev_acc_id from gms_device_account_dui t where 1!=1";
			}
			if (null != work_hours && (!"".equals(work_hours))) {
				bywxSql = "select   m.work_hours , sum(w.use_num) as  realnum  from   gms_device_zy_bywx m, gms_device_zy_wxbymat w,gms_mat_recyclemat_info r  where m.dev_acc_id in ("
						+ devSql
						+ ")  and m.project_info_id = r.project_info_id   and   m.project_info_id is not null and   r.project_info_id is not null  and   m.bsflag='0'  and  r.wz_type='3'  and r.bsflag='0'  and    r.wz_id=w.wz_id and   m.usemat_id = w.usemat_id and w.coding_code_id='"
						+ coding_code_id
						+ "' and to_number(m.work_hours)>="
						+ work_hours;
				isAdd = true;
			} else {
				bywxSql = "select   m.work_hours , sum(w.use_num) as  realnum  from   gms_device_zy_bywx m, gms_device_zy_wxbymat w ,  gms_mat_recyclemat_info r where m.dev_acc_id in ("
						+ devSql
						+ ")  and   m.project_info_id is not null and   r.project_info_id is not null  and       m.bsflag='0'  and  r.wz_type='3'  and r.bsflag='0'   and  r.wz_id=w.wz_id   and    m.usemat_id = w.usemat_id and w.coding_code_id='"
						+ coding_code_id + "'";

				isAdd = true;
			}
			if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
				bywxSql += "    and  to_number(m.work_hours)<="
						+ s_work_hours_max;
				isAdd = true;
			}
			if (isAdd) {
				bywxSql += "  group by m.work_hours   order  by work_hours";
			}
			String bywxNew = "(" + bywxSql + ")  a";

			String preSql1 = "select  work_hours , realnum   from  " + bywxNew;

			String devSql2 = "";
			String bywxSql2 = "";

			boolean isAdd2 = false;
			if (null != self_num && (!"".equals(self_num))) {
				devSql2 = "select dev_acc_id from gms_device_account t where t.self_num= '"
						+ self_num
						+ "'  and t.dev_acc_id='"
						+ real_dev_acc_id
						+ "'";
			} else {
				devSql2 = "select dev_acc_id from gms_device_account t where 1!=1";
			}
			if (null != work_hours && (!"".equals(work_hours))) {
				bywxSql2 = "select   m.work_hours , sum(w.use_num) as  realnum  from   gms_device_zy_bywx m, gms_device_zy_wxbymat w, gms_mat_recyclemat_info  r  where m.dev_acc_id in ("
						+ devSql2
						+ ")  and   m.project_info_id = r.project_info_id   and    m.project_info_id is   null and   r.project_info_id is   null  and     m.bsflag='0'  and  r.wz_type='3'  and r.bsflag='0'  and  r.wz_id=w.wz_id  and   m.usemat_id = w.usemat_id and w.coding_code_id='"
						+ coding_code_id
						+ "' and to_number(m.work_hours)>="
						+ work_hours;
				isAdd2 = true;
			} else {
				bywxSql2 = "select   m.work_hours , sum(w.use_num) as  realnum  from   gms_device_zy_bywx m, gms_device_zy_wxbymat w   , gms_mat_recyclemat_info  r where m.dev_acc_id in ("
						+ devSql2
						+ ")  and     m.project_info_id is   null and   r.project_info_id is null  and  m.bsflag='0'  and  r.wz_type='3'  and r.bsflag='0'  and  r.wz_id=w.wz_id  and  m.usemat_id = w.usemat_id    and m.bsflag='0'   and w.coding_code_id='"
						+ coding_code_id + "'";

				isAdd2 = true;
			}
			if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
				bywxSql2 += "    and  to_number(m.work_hours)<="
						+ s_work_hours_max;
				isAdd2 = true;
			}
			if (isAdd2) {
				bywxSql2 += "  group by m.work_hours   order  by work_hours";
			}
			String bywxNew2 = "(" + bywxSql2 + ")  b";

			String preSql2 = "select  work_hours , realnum   from  " + bywxNew2;

			String table = "(   " + preSql1 + "    union all    " + preSql2
					+ ") devTable  where  devTable.work_hours='#' ";
			String bigTable = "select   sum(realnum) as  realnum  from "
					+ table + "  group by  work_hours  order  by work_hours ";

			List<String> equipmentList = new ArrayList<String>();
			IPureJdbcDao timeDao = BeanFactory.getPureJdbcDAO();
			List<Map> mapTimes = timeDao.queryRecords(bywxSql);
			IPureJdbcDao timeDao2 = BeanFactory.getPureJdbcDAO();
			List<Map> mapTimes2 = timeDao2.queryRecords(bywxSql2);
			Set<Integer> timeSet = new HashSet<Integer>();
			for (Map m : mapTimes) {
				timeSet.add(Integer.parseInt(m.get("work_hours").toString()));
			}
			for (Map m2 : mapTimes2) {
				timeSet.add(Integer.parseInt(m2.get("work_hours").toString()));
			}
			List<Integer> timeList = new ArrayList<Integer>(timeSet);
			Collections.sort(timeList);

			// if ((null != coding_code_id && (!"".equals(coding_code_id)))
			// && (null != coding_name && (!"".equals(coding_name)))) {
			// if (null != mapTimes) {
			// for (int i = 0; i < mapTimes.size(); i++) {
			// Map mapTime = mapTimes.get(i);
			// equipmentList.add(coding_code_id + "~"
			// + mapTime.get("work_hours").toString());
			// }
			// }
			//
			// }
			// if ((null != coding_code_id && (!"".equals(coding_code_id)))
			// && (null != coding_name && (!"".equals(coding_name)))) {
			// if (null != mapTimes2) {
			// for (int i = 0; i < mapTimes2.size(); i++) {
			// Map mapTime = mapTimes2.get(i);
			// equipmentList.add(coding_code_id + "~"
			// + mapTime.get("work_hours").toString());
			// }
			// }
			//
			// }

			if ((null != coding_code_id && (!"".equals(coding_code_id)))
					&& (null != coding_name && (!"".equals(coding_name)))) {
				if (null != timeList) {
					for (int i = 0; i < timeList.size(); i++) {
						Integer time = timeList.get(i);
						equipmentList.add(coding_code_id + "~"
								+ time.toString());
					}
				}

			}
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();

			Iterator<String> iter = equipmentList.iterator();
			while (iter.hasNext()) {
				String value = iter.next();
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(bigTable);
				presqli = presqli.replaceAll("#", strArray[1]);
				selectSql.append(presqli);
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", self_num);
					data.put("excel_column_val1", strArray[1]);
					equipmentNum = resultMap.get("realnum").toString();
					data.put("excel_column_val2", equipmentNum);
					datas.add(data);
				}
			}
			String excelName = "��̨Դ���ϲ�������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Դ���");
			headerList.add("�ۼƹ���Сʱ");
			headerList.add("����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		// ��̨����������ϸ
		if ("sbjxhmx".equals(exportFlag)) {
			String wz_id = msg.getValue("wz_id");
			IPureJdbcDao wzjdbc = BeanFactory.getPureJdbcDAO();

			String wz_name = wzjdbc
					.queryRecordBySQL(
							"select  wz_name from gms_mat_infomation where  wz_id='"
									+ wz_id + "'").get("wz_name").toString();
			String coding_code_id = msg.getValue("coding_code_id");
			String self_num = msg.getValue("self_num");
			String price = msg.getValue("price");
			String bywx_begin_date = msg.getValue("begin");
			String bywx_end_date = msg.getValue("end");
			IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
			String projectName = this.getProjectName(projectInfoNo,
					"��̨��Դ���ϲ�������ͳ��");
			String searchSql = "select '"
					+ wz_name
					+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price"
					+ "      from gms_device_zy_bywx      x,"
					+ "      gms_device_zy_wxbymat   w,"
					+ "       gms_mat_recyclemat_info i"
					+ "       where x.project_info_id =i.project_info_id  and  x.project_info_id  is not null and i.project_info_id is not null and    i.wz_type='3'  and  i.bsflag='0'  and     x.dev_acc_id in (select t.dev_acc_id"
					+ "                   from gms_device_account_dui t"
					+ "                 where t.self_num = '"
					+ self_num
					+ "')"
					+ "       and x.usemat_id = w.usemat_id"
					+ "       and w.wz_id = '"
					+ wz_id
					+ "'"
					+ "       and w.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.bsflag = '0'"
					+ "       and x.bywx_date>=to_date('" + bywx_begin_date
					+ "','yyyy-mm-dd') and x.bywx_date<=to_date('"
					+ bywx_end_date + "','yyyy-mm-dd')";

			String searchSql2 = "select '"
					+ wz_name
					+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price"
					+ "      from gms_device_zy_bywx      x,"
					+ "      gms_device_zy_wxbymat   w,"
					+ "       gms_mat_recyclemat_info i"
					+ "       where  x.project_info_id is null  and  i.project_info_id is null and  i.wz_type='3'  and  i.bsflag='0'  and  x.dev_acc_id in (select t.dev_acc_id"
					+ "                   from gms_device_account t"
					+ "                 where t.self_num = '"
					+ self_num
					+ "')"
					+ "       and x.usemat_id = w.usemat_id"
					+ "       and w.wz_id = '"
					+ wz_id
					+ "'"
					+ "       and w.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.bsflag = '0'"
					+ "       and x.bywx_date>=to_date('" + bywx_begin_date
					+ "','yyyy-mm-dd') and x.bywx_date<=to_date('"
					+ bywx_end_date + "','yyyy-mm-dd')";

			String bigTable = "select * from  (" + searchSql + "   union all  "
					+ searchSql2 + ") aa";

			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			List<Map> resultList = jdbcDAO.queryRecords(bigTable);
			List<Map> datas = new ArrayList<Map>();
			if (null != resultList) {
				for (int i = 0; i < resultList.size(); i++) {
					Map map = resultList.get(i);
					Map data = new HashMap();
					data.put("excel_column_val0", map.get("wz_name"));
					data.put("excel_column_val1", map.get("actual_price"));
					data.put("excel_column_val2", map.get("use_num"));
					data.put("excel_column_val3", map.get("bywx_date"));
					data.put("excel_column_val4", map.get("price"));
					datas.add(data);
				}
			}
			String excelName = "��̨������ϸ����ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��������");
			headerList.add("����");
			headerList.add("��������");
			headerList.add("��������");
			headerList.add("���Ľ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}

		// ��̨��Դĳ�ಿ����ϸ
		if ("dtbjxhmx".equals(exportFlag)) {

			String self_num = msg.getValue("self_num");

			String coding_code_id = msg.getValue("coding_code_id");
			String bywx_begin_date = msg.getValue("bywx_begin_date");
			String bywx_end_date = msg.getValue("bywx_end_date");

			IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
			String sqlCodingName = "select  coding_name from comm_coding_sort_detail where coding_sort_id='5110000188' and coding_code_id='"
					+ coding_code_id + "'";
			Map map = jdbc.queryRecordBySQL(sqlCodingName);
			String coding_name = map.get("coding_name").toString();
			String projectName = this.getProjectName(projectInfoNo,
					"��̨��Դ���ϲ�������ͳ��");

			String searchSql = "select wz_id, sum(use_num) as realnum"
					+ " from (select m.wz_id, r.actual_price, m.use_num"
					+ "    from gms_device_zy_wxbymat   m,"
					+ "        gms_mat_recyclemat_info r,"
					+ "            gms_mat_infomation      i"
					+ "      where m.usemat_id in "
					+ "              (select o.usemat_id"
					+ "                 from gms_device_zy_bywx o"
					+ "                where  o.project_info_id=r.project_info_id  and  o.project_info_id is not null  and  o.dev_acc_id in"
					+ "                      (select t.dev_acc_id"
					+ "                         from gms_device_account_dui t"
					+ "                         where t.self_num = '"
					+ self_num
					+ "') and o.bywx_date>=to_date('"
					+ bywx_begin_date
					+ "','yyyy-mm-dd') and o.bywx_date<=to_date('"
					+ bywx_end_date
					+ "','yyyy-mm-dd') and m.usemat_id=o.usemat_id)"
					+ "          and m.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "           and r.wz_id = m.wz_id"
					+ "           and m.wz_id = i.wz_id  and r.wz_type='3'  and r.bsflag = '0'  and r.project_info_id  is not null ) a  where a.wz_id='@' "
					+ "  group by wz_id";

			String searchSql1 = "select wz_id, sum(use_num) as realnum"
					+ " from (select m.wz_id, r.actual_price, m.use_num"
					+ "    from gms_device_zy_wxbymat   m,"
					+ "        gms_mat_recyclemat_info r,"
					+ "            gms_mat_infomation      i"
					+ "      where m.usemat_id in "
					+ "              (select o.usemat_id"
					+ "                 from gms_device_zy_bywx o"
					+ "                where   o.project_info_id  is  null and  o.dev_acc_id in"
					+ "                      (select t.dev_acc_id"
					+ "                         from gms_device_account t"
					+ "                         where t.self_num = '"
					+ self_num
					+ "') and o.bywx_date>=to_date('"
					+ bywx_begin_date
					+ "','yyyy-mm-dd') and o.bywx_date<=to_date('"
					+ bywx_end_date
					+ "','yyyy-mm-dd') and m.usemat_id=o.usemat_id)"
					+ "          and m.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "           and r.wz_id = m.wz_id"
					+ "           and m.wz_id = i.wz_id  and r.wz_type='3'  and r.bsflag = '0'  and r.project_info_id is null ) a  where a.wz_id='@' "
					+ "  group by wz_id";

			String bigTable = "select sum(realnum) as realnum  from ("
					+ searchSql1 + "  union all  " + searchSql + ")  aa ";

			String x_nameSql = "select distinct i.wz_id, i.wz_name"
					+ "    from gms_mat_infomation   i ,gms_mat_recyclemat_info rr  "
					+ "     where i.wz_id=rr.wz_id and rr.wz_type='3' and rr.bsflag='0' and  rr.project_info_id is  not null  and   i.wz_id in("
					+ "          select wz_id"
					+ "             from (select m.wz_id"
					+ "               from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
					+ "              where m.usemat_id in"
					+ "                    (select o.usemat_id"
					+ "                      from gms_device_zy_bywx o"
					+ "                      where  o.project_info_id=r.project_info_id  and  o.project_info_id is not null and  o.dev_acc_id in"
					+ "                            (select t.dev_acc_id"
					+ "                              from gms_device_account_dui t"
					+ "                             where t.self_num = '"
					+ self_num
					+ "'))"
					+ "                and m.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "                and r.wz_id = m.wz_id and r.wz_type='3' and r.bsflag='0'))";

			String x_nameSql1 = "select distinct i.wz_id, i.wz_name"
					+ "    from gms_mat_infomation   i ,gms_mat_recyclemat_info rr"
					+ "     where i.wz_id=rr.wz_id and rr.wz_type='3' and rr.bsflag='0'  and  rr.project_info_id is null   and   i.wz_id in("
					+ "          select wz_id"
					+ "             from (select m.wz_id"
					+ "               from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
					+ "              where m.usemat_id in"
					+ "                    (select o.usemat_id"
					+ "                      from gms_device_zy_bywx o"
					+ "                      where   o.project_info_id is null  and  o.dev_acc_id in"
					+ "                            (select t.dev_acc_id"
					+ "                              from gms_device_account t"
					+ "                             where t.self_num = '"
					+ self_num
					+ "'))"
					+ "                and m.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "                and r.wz_id = m.wz_id  and r.wz_type='3' and r.bsflag='0'))";

			IPureJdbcDao jdbc2 = BeanFactory.getPureJdbcDAO();
			// �洢������
			List<Map> wzMapList = jdbc2.queryRecords(x_nameSql);
			Set<String> wzList = new HashSet<String>();
			for (int i = 0; i < wzMapList.size(); i++) {
				wzList.add(wzMapList.get(i).get("wz_id") + "~"
						+ wzMapList.get(i).get("wz_name"));
			}

			IPureJdbcDao jdbc1 = BeanFactory.getPureJdbcDAO();
			// �洢������
			List<Map> wzMapList1 = jdbc.queryRecords(x_nameSql1);

			for (int i = 0; i < wzMapList1.size(); i++) {
				wzList.add(wzMapList1.get(i).get("wz_id") + "~"
						+ wzMapList1.get(i).get("wz_name"));
			}

			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			Iterator<String> iter = wzList.iterator();
			while (iter.hasNext()) {
				String value = iter.next();
				String[] strArray = value.split("~");
				String wzCode = strArray[0];
				String wzName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(bigTable);
				presqli = presqli.replaceAll("@", strArray[0]);
				selectSql.append(presqli);
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", wzName);
					// data.put("excel_column_val1", strArray[1]);
					equipmentNum = resultMap.get("realnum").toString();
					data.put("excel_column_val1", equipmentNum);
					datas.add(data);
				}
			}
			String excelName = "��̨Դ���ϲ�����ϸ����ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��������");
			headerList.add("��������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}

		// ��̨��Դĳһ������ͬ�ۼƹ���Сʱ���ϲ�������ͳ��
		if ("SDFX".equals(exportFlag)) {

			String project_info_id = msg.getValue("project_info_id");
			String self_num = msg.getValue("self_num");
			String work_hours = msg.getValue("work_hours");
			String coding_code_id = msg.getValue("coding_code_id");
			String s_work_hours_max = msg.getValue("s_work_hours_max");

			IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
			String sqlCodingName = "select  coding_name from comm_coding_sort_detail where coding_sort_id='5110000188' and coding_code_id='"
					+ coding_code_id + "'";
			Map map = jdbc.queryRecordBySQL(sqlCodingName);
			String coding_name = map.get("coding_name").toString();
			String projectName = this.getProjectName(projectInfoNo,
					"��̨��Դ���ϲ�������ͳ��");

			String devSql = "";
			String bywxSql = "";
			boolean isAdd = false;
			if (null != self_num && (!"".equals(self_num))) {
				devSql = "select dev_acc_id from gms_device_account_dui t where t.self_num= '"
						+ self_num + "'";
			} else {
				devSql = "select dev_acc_id from gms_device_account_dui t where 1!=1";
			}
			if (null != work_hours && (!"".equals(work_hours))) {
				bywxSql = "select   m.usemat_id   ,work_hours    from   gms_device_zy_bywx m where m.bsflag='0'   and   m.dev_acc_id in ("
						+ devSql + ") and m.work_hours>=" + work_hours;
				isAdd = true;
			} else {
				bywxSql = "select   m.usemat_id  ,work_hours   from   gms_device_zy_bywx m where   m.bsflag='0'   and   m.dev_acc_id in ("
						+ devSql + ")";
				isAdd = true;
			}
			if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
				bywxSql += "    and   m.work_hours<=" + s_work_hours_max;
				isAdd = true;
			}
			if (isAdd) {
				bywxSql += "   order  by work_hours";
			}
			String bywxNew = "(" + bywxSql + ")  a";
			IPureJdbcDao timeDao = BeanFactory.getPureJdbcDAO();
			List<Map> mapTimes = timeDao.queryRecords(bywxSql);

			List<String> equipmentList = new ArrayList<String>();
			if ((null != coding_code_id && (!"".equals(coding_code_id)))
					&& (null != coding_name && (!"".equals(coding_name)))) {
				if (null != mapTimes) {
					for (int i = 0; i < mapTimes.size(); i++) {
						Map mapTime = mapTimes.get(i);
						equipmentList.add(coding_code_id + "~"
								+ mapTime.get("work_hours").toString());
					}
				}

			}
			String preSql = "select   use_num as realnum  from gms_device_zy_wxbymat   t , gms_mat_recyclemat_info  r, "
					+ bywxNew
					+ "   where   r.wz_type='3'  and r.bsflag='0'  and  r.wz_id=t.wz_id  and  t.coding_code_id='@' and a.usemat_id=t.usemat_id and a.work_hours='#'";
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			for (int i = 0; i < equipmentList.size(); i++) {
				String value = (String) equipmentList.get(i);
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				presqli = presqli.replaceAll("@", strArray[0]);
				presqli = presqli.replaceAll("#", strArray[1]);
				selectSql.append(presqli);
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", self_num);
					data.put("excel_column_val1", strArray[1]);
					equipmentNum = resultMap.get("realnum").toString();
					data.put("excel_column_val2", equipmentNum);
					datas.add(data);
				}
			}
			String excelName = "��̨Դ���ϲ�������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Դ���");
			headerList.add("�ۼƹ���Сʱ");
			headerList.add("����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		// ��̨��Դĳһ������ͬ�ۼƹ���Сʱ���ϲ�������ͳ��
		if ("MDFX".equals(exportFlag)) {
			String project_info_id = msg.getValue("project_info_id");
			// ��Ŀ���
			String pji = null;
			if (null != projectInfoNo && (!"".equals(projectInfoNo))) {
				pji = projectInfoNo;
			}
			String projectName = this.getProjectName(pji, "��̨��Դ���ϲ�������ͳ��");
			String devSql = "";
			String bywxSql = "";
			// �Ա��
			String coding_code_id = msg.getValue("coding_code_id");
			String coding_name = "";
			String codingNameSql = "select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' and coding_code_id='"
					+ coding_code_id + "'";
			IPureJdbcDao codingNameDao = BeanFactory.getPureJdbcDAO();
			coding_name = codingNameDao.queryRecordBySQL(codingNameSql)
					.get("coding_name").toString();
			String work_hours = msg.getValue("work_hours");
			String s_work_hours_max = msg.getValue("s_work_hours_max");
			String self_num = msg.getValue("self_num");

			String[] self_nums = self_num.split(",");
			String selfNumsStr = "";
			List<String> equipmentList = new ArrayList<String>();
			for (int i = 0; i < self_nums.length; i++) {
				selfNumsStr += "'" + self_nums[i] + "',";
				equipmentList.add(coding_code_id + "~" + self_nums[i]);
			}
			selfNumsStr = selfNumsStr
					.substring(0, selfNumsStr.lastIndexOf(","));
			if (null != selfNumsStr && (!"".equals(selfNumsStr))) {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.self_num in  ("
						+ selfNumsStr + ")";
			}
			if (null != work_hours && (!"".equals(work_hours))) {
				bywxSql = "select x.usemat_id from gms_device_zy_bywx x where  x.project_info_id is not null and   x.bsflag='0'  and   x.dev_acc_id in ("
						+ devSql
						+ ") and x.bywx_date>=to_date('"
						+ work_hours
						+ "','yyyy-mm-dd')";
			} else {
				bywxSql = "select x.usemat_id from gms_device_zy_bywx x where  x.project_info_id is not null and      x.bsflag='0'  and   x.dev_acc_id in ("
						+ devSql + ")";
			}

			if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
				bywxSql += "and x.bywx_date<=to_date('" + s_work_hours_max
						+ "','yyyy-mm-dd')";
			}

			String preSql = "select sum(use_num) as realnum  from gms_device_zy_wxbymat z    left join  gms_mat_recyclemat_info r on z.wz_id=r.wz_id   where r.project_info_id is not null and   r.wz_type='3'  and  r.bsflag='0'  and  z.usemat_id in"
					+ "(select t.usemat_id  from gms_device_zy_bywx t  where r.project_info_id=t.project_info_id    and   t.project_info_id is not null   and  t.bsflag='0'  and  t.dev_acc_id in  (select dev_acc_id"
					+ "    from   gms_device_account_dui d   where d.self_num = '#')) and z.coding_code_id='@' and usemat_id in ("
					+ bywxSql + ") ";

			String devSql1 = "select dev_acc_id from gms_device_account t where t.self_num in ("
					+ selfNumsStr + ")";
			String bywxSql1;
			// ������ʼ����
			if (null != work_hours && (!"".equals(work_hours))) {
				bywxSql1 = "select   m.usemat_id      from   gms_device_zy_bywx m where   m.project_info_id is null  and  m.bsflag='0'  and   m.dev_acc_id in ("
						+ devSql1
						+ ") and m.bywx_date>=to_date('"
						+ work_hours
						+ "', 'yyyy-mm-dd')";
			} else {
				bywxSql1 = "select   m.usemat_id      from   gms_device_zy_bywx m where     m.project_info_id is null  and   m.bsflag='0'  and   m.dev_acc_id in ("
						+ devSql1 + ")";
			}
			// ������������
			if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
				bywxSql1 += "    and   m.bywx_date<=to_date('"
						+ s_work_hours_max + "' ,'yyyy-mm-dd')";
			}

			String preSql1 = "select sum(use_num) as realnum  from gms_device_zy_wxbymat z  left join  gms_mat_recyclemat_info r on z.wz_id=r.wz_id   where   r.project_info_id is null  and  r.wz_type='3'  and  r.bsflag='0'  and   z.usemat_id in"
					+ "(select t.usemat_id  from gms_device_zy_bywx t  where  t.project_info_id is null  and   t.bsflag='0'  and t.dev_acc_id in  (select dev_acc_id"
					+ "    from   gms_device_account d   where d.self_num = '#')) and z.coding_code_id='@' and usemat_id in ("
					+ bywxSql1 + ") ";

			String bigTable = "select sum(realnum) as realnum from (" + preSql
					+ "    union all  " + preSql1 + ") aa";

			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			for (int i = 0; i < equipmentList.size(); i++) {
				String value = (String) equipmentList.get(i);
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(bigTable);
				presqli = presqli.replaceAll("@", strArray[0]);
				presqli = presqli.replace("#", strArray[1]);
				selectSql.append(presqli);
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", equipmentName);
					data.put("excel_column_val1", coding_name);
					if (null == resultMap.get("realnum")) {
						equipmentNum = "0";
					} else {
						equipmentNum = resultMap.get("realnum").toString()
								.trim();
						if (StringUtil.isBlank(equipmentNum)) {
							equipmentNum = "0";
						}
					}

					System.out.println("equipmentNum:=" + equipmentNum);
					data.put("excel_column_val2", equipmentNum);
					datas.add(data);
				}
			}

			String excelName = "��̨��Դ���ϲ�������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Դ���");
			headerList.add("��������");
			headerList.add("����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		// ĳ̨��ĳ��Ŀ��Դ���ϲ�������ͳ��
		if ("TORPC".equals(exportFlag)) {

			String project_info_id = msg.getValue("project_info_id");
			String devSql = "";
			String projectName = this.getProjectName(project_info_id,
					"����Ŀ����������ϸ");
			String self_num = msg.getValue("self_num");
			String start_date = msg.getValue("start_date");
			String end_date = msg.getValue("end_date");
			// ˧ѡ������������Ŀ
			String selectProjectSql = "select t.project_info_no"
					+ "     from    gp_task_project t, gp_task_project_dynamic t2"
					+ "     where t.project_info_no = t2.project_info_no and t.bsflag='0'";
			if (null != project_info_id && (!"".equals(project_info_id))) {
				selectProjectSql += "     and  t.project_info_no='"
						+ project_info_id + "'";
			}
			if (null != start_date && (!"".equals(start_date))) {
				selectProjectSql += "   and  t.acquire_end_time>=to_date('"
						+ start_date + "','yyyy-mm-dd')";
			}
			if (null != end_date && (!"".equals(end_date))) {
				selectProjectSql += "   and  t.acquire_end_time<=to_date('"
						+ end_date + "','yyyy-mm-dd')";
			}

			if (null != self_num && (!"".equals(self_num))) {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where  d.project_info_id  in ("
						+ selectProjectSql
						+ ")"
						+ "   and  d.self_num ='"
						+ self_num + "'";
			} else {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.project_info_id  in ("
						+ selectProjectSql + ")";
			}

			List<String> equipmentList = new ArrayList<String>();

			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			List<Map> listMap = dao
					.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				String element = map.get("coding_code_id").toString() + "~"
						+ map.get("coding_name");
				equipmentList.add(element);

			}

			String preSql = " select sum(realnum) as realnum , coding_code_id"
					+ "  from (select (m.use_num) as realnum, coding_code_id"
					+ "   from gms_device_zy_wxbymat m   left join gms_mat_recyclemat_info r   on r.wz_id=m.wz_id "
					+ "  where   r.wz_type = '3'   and r.bsflag = 0  and r.project_info_id is not null  and   m.usemat_id in"
					+ "  (select x.usemat_id"
					+ "     from gms_device_zy_bywx x"
					+ "   where x.bsflag='0'  and x.project_info_id=r.project_info_id and   x.project_info_id='"
					+ project_info_id + "'  and   x.dev_acc_id in (" + devSql
					+ "))" + "   and m.coding_code_id = '@'" + "   ) a"
					+ " group by coding_code_id";
			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			for (int i = 0; i < equipmentList.size(); i++) {
				String value = (String) equipmentList.get(i);
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", projectName);
					data.put("excel_column_val1", equipmentName);
					equipmentNum = resultMap.get("realnum").toString();
					data.put("excel_column_val2", equipmentNum);
					datas.add(data);
				}
			}

			String excelName = "����Ŀ����������ϸ����ͳ��.xls";
			List<String> headerList = new ArrayList<String>();

			headerList.add("��Ŀ����");
			headerList.add("��������");
			headerList.add("����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		// ����Ŀ����������ϸ
		if ("TORPM".equals(exportFlag)) {
			// project_info_id=<%=project_info_id%>
			// &self_num=<%=self_num%>
			// &start_date=<%=start_date%>&end_date=<%=end_date%>

			String project_info_id = msg.getValue("project_info_id");
			String projectName = this.getProjectName(project_info_id,
					"����Ŀ��������������ϸ");
			String devSql = "";

			String self_num = msg.getValue("self_num");
			String start_date = msg.getValue("start_date");
			String end_date = msg.getValue("end_date");
			// ˧ѡ������������Ŀ
			String selectProjectSql = "select t.project_info_no"
					+ "     from    gp_task_project t, gp_task_project_dynamic t2"
					+ "     where t.project_info_no = t2.project_info_no and t.bsflag='0'";
			if (null != project_info_id && (!"".equals(project_info_id))) {
				selectProjectSql += "     and  t.project_info_no='"
						+ project_info_id + "'";
			}
			if (null != start_date && (!"".equals(start_date))) {
				selectProjectSql += "   and  t.acquire_end_time>=to_date('"
						+ start_date + "','yyyy-mm-dd')";
			}
			if (null != end_date && (!"".equals(end_date))) {
				selectProjectSql += "   and  t.acquire_end_time<=to_date('"
						+ end_date + "','yyyy-mm-dd')";
			}

			if (null != self_num && (!"".equals(self_num))
					&& (!"null".equals(self_num))) {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where  d.project_info_id  in ("
						+ selectProjectSql
						+ ")"
						+ "   and  d.self_num ='"
						+ self_num + "'";
			} else {
				devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.project_info_id  in ("
						+ selectProjectSql + ")";
			}

			List<String> equipmentList = new ArrayList<String>();

			IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
			List<Map> listMap = dao
					.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				String element = map.get("coding_code_id").toString() + "~"
						+ map.get("coding_name");
				equipmentList.add(element);

			}

			String preSql = " select sum(realnum) as realnum , coding_code_id"
					+ "  from (select (m.use_num * r.actual_price) as realnum, coding_code_id"
					+ "   from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
					+ "  where   r.bsflag='0'  and r.wz_type='3' and r.project_info_id is not null  and   m.usemat_id in"
					+ "  (select x.usemat_id"
					+ "     from gms_device_zy_bywx x"
					+ "   where   x.project_info_id =r.project_info_id  and  x.bsflag='0' and  x.project_info_id='"
					+ project_info_id + "'  and x.dev_acc_id in (" + devSql
					+ "))" + "  and m.coding_code_id = '@'"
					+ "   and r.wz_id = m.wz_id) a"
					+ " group by coding_code_id";

			List<Map<String, String>> datas = new ArrayList<Map<String, String>>();
			for (int i = 0; i < equipmentList.size(); i++) {
				String value = (String) equipmentList.get(i);
				String[] strArray = value.split("~");
				String equipmentCode = strArray[0];
				String equipmentName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(preSql);
				selectSql.append(presqli.replaceAll("@", strArray[0]));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("�������ѯ�����ֶβ�����!");
				}
				// ��ȡ���
				String equipmentNum = "";
				if (resultMap != null) {
					Map<String, String> data = new HashMap<String, String>();
					data.put("excel_column_val0", projectName);
					data.put("excel_column_val1", equipmentName);
					equipmentNum = resultMap.get("realnum").toString();
					data.put("excel_column_val2", equipmentNum);
					datas.add(data);
				}
			}

			String excelName = "����Ŀ�������Ľ����ϸ.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Ŀ����");
			headerList.add("��������");
			headerList.add("���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		// ����ӻ�е�豸ͳ��
		if ("dzdjxsbtj".equals(exportFlag)) {
			StringBuffer sql = new StringBuffer();
			sql.append(" select * from ( select case when substr(t.dev_type, 1, 3) = 'S05' then '���͡�������ʩ' when substr(t.dev_type, 1, 3) = 'S06' then 'ʯ��ר���豸' when substr(t.dev_type, 1, 3) = 'S07' then 'ʩ����е'");
			sql.append(" when substr(t.dev_type, 1, 3) = 'S08' then '�����豸' when substr(t.dev_type,1,3)='S09' then '�����豸����ʩ' when substr(t.dev_type, 1, 3) = 'S13' then '���޼ӹ��豸' end as excel_column_val0,count(*) as excel_column_val1");
			sql.append(" from gms_device_account_dui t where t.project_info_id='"
					+ projectInfoNo
					+ "' and ( t.dev_type like 'S05%' or t.dev_type like 'S06%' or t.dev_type like 'S07%' or t.dev_type like 'S08%' or t.dev_type like 'S09%' or t.dev_type like 'S13%' ) ");
			sql.append(" group by substr(t.dev_type,1,3) order by substr(t.dev_type,1,3) )");
			sql.append(" union all ");
			sql.append(" select * from ( select case when substr(t.dev_type, 1, 5) = 'S1407' then 'ʯ��ר������-�����豸' when substr(t.dev_type, 1, 5) = 'S1601' then 'ҰӪ��' end as excel_column_val0,count(*) as excel_column_val1");
			sql.append(" from gms_device_account_dui t where t.project_info_id='"
					+ projectInfoNo
					+ "' and ( t.dev_type like 'S1407%' or t.dev_type like 'S1601%' ) ");
			sql.append(" group by substr(t.dev_type,1,5) order by substr(t.dev_type,1,5) )");
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			// ��ȡ��Ŀ����
			String projectName = getProjectName(projectInfoNo, "����ӻ�е�豸ͳ��");
			String excelName = "����ӻ�е�豸ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("�豸����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����ӻ�е�豸��Ϣ
		if ("dzdjxsbxx".equals(exportFlag)) {
			// �豸����
			String dev_type = msg.getValue("code");
			StringBuffer selectSql = new StringBuffer()
					.append("select dev_name as excel_column_val0,dev_model as excel_column_val1,license_num as excel_column_val4,self_num as excel_column_val2,dev_sign as excel_column_val3,asset_coding as excel_column_val5,")
					.append("oprtbl.operator_name as excel_column_val7,teamsd.coding_name as excel_column_val6 ")
					.append("from gms_device_account_dui dui ")
					.append("left join (select device_account_id,operator_name from ( ")
					.append("select tmp.device_account_id,tmp.operator_name,row_number() ")
					.append("over(partition by device_account_id order by length(operator_name) desc ) as seq ")
					.append("from (select device_account_id,wmsys.wm_concat(operator_name) ")
					.append("over(partition by device_account_id order by operator_name) as operator_name ")
					.append("from gms_device_equipment_operator where bsflag='0' ) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id ")
					.append("left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = dui.dev_team ")
					.append("where dui.bsflag = '0' and dui.project_info_id='"
							+ projectInfoNo + "' ");
			if (dev_type.contains(",")) {
				String[] codeArray = dev_type.split(",");
				selectSql.append(" and (dev_type like 'S").append(codeArray[0])
						.append("%' ");
				selectSql.append("      or dev_type like 'S")
						.append(codeArray[1]).append("%') ");
			} else {
				selectSql.append(" and dev_type like 'S").append(dev_type)
						.append("%' ");
			}
			selectSql.append("order by dui.dev_team,dui.dev_type ");
			List<Map> list = jdbcDao.queryRecords(selectSql.toString());
			// ��ȡ��Ŀ����
			String projectName = getProjectName(projectInfoNo, "����ӻ�е�豸��Ϣ");
			String excelName = "����ӻ�е�豸��Ϣ.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("AMIS�ʲ����");
			headerList.add("����");
			headerList.add("������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����Ӳɼ��豸ͳ��
		if ("dzdcjsbtj".equals(exportFlag)) {
			String conditionsql = "select device_id,dev_name from gms_device_collectinfo where is_leaf=0 and node_level='1' order by dev_code";
			List<Map> conditionList = jdbcDao.queryRecords(conditionsql);
			String devsql = "select distinct b.revtotal as excel_column_val1,dui.dev_name as excel_column_val0 from gms_device_account_dui dui inner join (select count(*) as revtotal from gms_device_account_dui dui where dui.dev_type like'S14050101%' and dui.project_info_id='"
					+ projectInfoNo
					+ "' and nvl(dui.bsflag,0)!='N') b on 1=1 where dui.dev_type like 'S14050101%' and dui.project_info_id='"
					+ projectInfoNo
					+ "' and nvl(dui.bsflag,0)!='N' union all select distinct b.revtotal as excel_column_val1,'�첨��' as excel_column_val0 from gms_device_account_dui dui inner join (select count(*) as revtotal from gms_device_account_dui dui where dui.dev_type like'S14050208%' and dui.project_info_id='"
					+ projectInfoNo
					+ "' and nvl(dui.bsflag,0)!='N') b on 1=1 where dui.dev_type like'S14050208%' and dui.project_info_id='"
					+ projectInfoNo + "' and nvl(dui.bsflag,0)!='N'";
			String sumSql = "select device_id,dev_name as excel_column_val0,revtotal as excel_column_val1 from (";
			for (int i = 0; i < conditionList.size(); i++) {
				Map tmpMap = conditionList.get(i);
				if (i != 0) {
					sumSql += "union ";
				}
				sumSql += "(select '"
						+ i
						+ "' as seq,'"
						+ tmpMap.get("device_id")
						+ "' as device_id,dui.dev_name,sum(dui.total_num) as revtotal "
						+ "from gms_device_coll_account_dui dui "
						+ "where dui.project_info_id='" + projectInfoNo
						+ "' and dev_name like'%" + tmpMap.get("dev_name")
						+ "' and nvl(dui.bsflag,0)!='N' group by dev_name ) ";
			}
			sumSql += ") order by seq";
			List<Map> summap = jdbcDao.queryRecords(sumSql);
			List<Map> list = jdbcDao.queryRecords(devsql);
			if (summap != null && summap.size() > 0) {
				for (int i = 0; i < summap.size(); i++) {
					list.add(summap.get(i));
				}
			}
			// ��ȡ��Ŀ����
			String projectName = getProjectName(projectInfoNo, "����Ӳɼ��豸ͳ��");
			String excelName = "����Ӳɼ��豸ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("�豸����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����ӻ�е�豸���ڼ��ͺ�ͳ�Ʊ�
		if ("dzdjxsbkqjyhtj".equals(exportFlag)) {
			// ��ʼ����
			String start_date = msg.getValue("start_date");
			// ��������
			String end_date = msg.getValue("end_date");
			// ���պ�
			String s_license_num = msg.getValue("s_license_num");
			String sql = "";
			sql += "select dev_name as excel_column_val0,dev_model as excel_column_val1, self_num as excel_column_val2,dev_sign as excel_column_val3,license_num as excel_column_val4,chuqinnum as excel_column_val5,daigongnum as excel_column_val6,jianxiunum as excel_column_val7,oilnum as excel_column_val8,workhour as excel_column_val9,drillingfootage as excel_column_val10,mileage as excel_column_val11,dwyh as excel_column_val12 ";
			sql += " from (select a.dev_acc_id,a.dev_name,a.dev_type,a.actual_in_time,a.dev_model,a.self_num,a.dev_sign,a.license_num,a.oilnum,a.mileage,a.drillingfootage,a.workhour,sum(a.daigongnum) daigongnum,sum(a.jianxiunum) jianxiunum,sum(a.kaoqin) chuqinnum,";
			sql += " case when a.dev_type is null then 0 when (substr(a.dev_type,0,3)='S08' and a.mileage!=0) then trunc((a.oilnum/a.mileage*100),3) when (substr(a.dev_type,0,5)='S0622' and a.mileage!=0) then trunc((a.oilnum/a.mileage*100),3) when (substr(a.dev_type,0,5)='S0601' and a.drillingfootage !=0) then trunc((a.oilnum/a.drillingfootage),3) when (substr(a.dev_type,0,5)='S0623' and a.workhour !=0) then trunc((a.oilnum/a.workhour),3) when (substr(a.dev_type,0,5)='S0901' and a.workhour !=0) then trunc((a.oilnum/a.workhour),3) else 0 end dwyh";
			sql += " from (";
			sql += " select  b.dev_acc_id, b.dev_type, b.dev_name,b.actual_in_time, b.dev_model, b.self_num, b.dev_sign, b.license_num,b.mileage,b.drillingfootage,b.workhour,b.daigongnum,b.jianxiunum,b.kaoqin, (case when sum(doi.oil_quantity) is null then 0 else sum(doi.oil_quantity) end + case when sum(oil.oil_num) is null then 0 else sum(oil.oil_num) end) oilnum from (select dui.dev_acc_id,dui.dev_type,dui.dev_name,dui.actual_in_time,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num,";
			sql += " case when sum(gdo.mileage) is null then 0 else sum(gdo.mileage) end mileage,";
			sql += " case when sum(gdo.drilling_footage) is null then 0 else sum(gdo.drilling_footage) end drillingfootage,";
			sql += " case when sum(gdo.work_hour) is null then 0 else sum(gdo.work_hour) end workhour,";
			sql += " decode(sd.coding_name,'����',sumnum,0) as daigongnum,";
			sql += " decode(sd.coding_name,'����',sumnum,0) as jianxiunum,decode(sd.coding_name, '����', sumnum, 0) as kaoqin";
			sql += " from (select device_account_id,timesheet_symbol ,count(1) as sumnum ";
			sql += " from bgp_comm_device_timesheet where bsflag = '0' ";
			if (StringUtils.isNotBlank(start_date)) {
				sql += " and timesheet_date>=to_date('" + start_date
						+ "','yyyy-mm-dd')";
			}
			if (StringUtils.isNotBlank(end_date)) {
				sql += " and timesheet_date<=to_date('" + end_date
						+ "','yyyy-mm-dd')";
			}
			sql += " group by device_account_id,timesheet_symbol ) tmp";
			sql += " join comm_coding_sort_detail sd on tmp.timesheet_symbol=sd.coding_code_id  ";
			sql += " join gms_device_account_dui dui on tmp.device_account_id=dui.dev_acc_id  ";
			sql += " left join GMS_DEVICE_OPERATION_INFO gdo on tmp.device_account_id = gdo.dev_acc_id";
			sql += " where dui.project_info_id='" + projectInfoNo
					+ "' and dui.bsflag = '0' ";
			if (StringUtils.isNotBlank(s_license_num)) {
				sql += " and dui.license_num='" + s_license_num + "' ";
			}
			sql += " group by dui.dev_acc_id,sd.coding_name,sumnum,sd.coding_name,sumnum,dui.dev_name,dui.dev_type,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num,dui.actual_in_time )b";
			sql += " left join bgp_comm_device_oil_info doi on b.dev_acc_id = doi.device_account_id ";
			sql += " left join (select tod.dev_acc_id ,case when sum(tod.oil_num) is null then 0 else sum(tod.oil_num) end oil_num";
			sql += " from gms_mat_teammat_out mto left join GMS_MAT_TEAMMAT_OUT_DETAIL tod on mto.teammat_out_id= tod.teammat_out_id and tod.bsflag='0'";
			sql += " where mto.bsflag='0' and mto.out_type='3' group by tod.dev_acc_id ) oil on b.dev_acc_id = oil.dev_acc_id ";
			sql += " group by b.dev_acc_id, b.dev_type, b.dev_name,b.actual_in_time, b.dev_model, b.self_num, b.dev_sign, b.license_num,b.mileage,b.drillingfootage,b.workhour,b.daigongnum,b.jianxiunum,b.kaoqin";
			sql += " )a ";
			sql += " group by a.dev_acc_id,a.dev_name,a.dev_type,a.dev_model,a.self_num,a.dev_sign,a.actual_in_time ,a.license_num,a.oilnum,a.mileage,a.drillingfootage,a.workhour)bb order by bb.dev_type,bb.actual_in_time desc";
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			// ��ȡ��Ŀ����
			String projectName = getProjectName(projectInfoNo,
					"����ӻ�е�豸���ڼ��ͺ�ͳ�Ʊ�");
			String excelName = "����ӻ�е�豸���ڼ��ͺ�ͳ�Ʊ�.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("��������");
			headerList.add("��������");
			headerList.add("��������");
			headerList.add("�ͺ��ۼ�(��)");
			headerList.add("����Сʱ�ۼ�");
			headerList.add("�꾮�����ۼ�");
			headerList.add("��ʻ����ۼ�");
			headerList.add("��λ�ͺ�");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// �������Ҫ�豸����������ͳ��
		if ("dzdzysbdgjxtj".equals(exportFlag)) {
			// �豸̨��id
			String devAccId = msg.getValue("devAccId");
			StringBuffer sql = new StringBuffer("")
					.append("select dui.dev_name as excel_column_val0,dui.dev_model as excel_column_val1,dui.self_num as excel_column_val2,dui.dev_sign as excel_column_val3,dui.license_num as excel_column_val4,")
					.append("to_char(timesheet_date, 'yyyy-mm-dd') as excel_column_val5,sd.coding_name as excel_column_val6 ")
					.append("from bgp_comm_device_timesheet ts,gms_device_account_dui dui,comm_coding_sort_detail sd ")
					.append("where ts.device_account_id=dui.dev_acc_id  ")
					.append("and ts.timesheet_symbol=sd.coding_code_id ")
					.append("and ts.timesheet_symbol!='5110000041000000001' ")
					.append("and ts.device_account_id='" + devAccId + "' ")
					.append("order by ts.timesheet_symbol,ts.timesheet_date ");
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			// ��ȡ��Ŀ����
			String projectName = getProjectName(projectInfoNo, "�������Ҫ�豸����������ͳ��");
			String excelName = "�������Ҫ�豸����������ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("����");
			headerList.add("�������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����ӻ����豸�䱸ͳ��
		if ("dzdjdsbpbtj".equals(exportFlag)) {
			StringBuffer sql = new StringBuffer();
			sql.append(" select * from (select t.dev_team,sd.coding_name as excel_column_val0, case when substr(t.dev_type, 1, 7) = 'S070301' then '������' "
					+ " when substr(t.dev_type, 1, 7) = 'S080101' then '����' when substr(t.dev_type, 1, 7) = 'S060101' then '��װ���' "
					+ " when substr(t.dev_type, 1, 7) = 'S060102' then '��̧�����' when substr(t.dev_type, 1, 7) = 'S080105' then 'Ƥ��' "
					+ " when substr(t.dev_type, 1, 7) = 'S062301' then '�ɿ���Դ' when substr(t.dev_type, 1, 7) = 'S080503' then 'ɳ̲Ħ�г�' end as excel_column_val1, "
					+ " count(*) as excel_column_val2 from gms_device_account_dui t left join comm_coding_sort_detail sd on t.dev_team = sd.coding_code_id "
					+ " where  t.project_info_id = '"
					+ projectInfoNo
					+ "' "
					+ " and (t.dev_type like 'S070301%' or t.dev_type like 'S080101%' or t.dev_type like 'S060101%' or t.dev_type like 'S060102%' or "
					+ " t.dev_type like 'S080105%' or t.dev_type like 'S062301%' or t.dev_type like 'S080503%') "
					+ " group by substr(t.dev_type, 1, 7),t.dev_team,sd.coding_name ");
			sql.append(" union all ");
			sql.append(" select t.dev_team,sd.coding_name as excel_column_val0, case  when substr(t.dev_type, 1, 5) = 'S0803' then '�ؿͳ���' "
					+ " when substr(t.dev_type, 1, 5) = 'S0804' then '���������ֳ���' when substr(t.dev_type, 1, 5) = 'S0806' then 'ר�ó���' "
					+ " when substr(t.dev_type, 1, 5) = 'S0901' then '�������' end as excel_column_val1, count(*) as excel_column_val2 "
					+ " from gms_device_account_dui t left join comm_coding_sort_detail sd on t.dev_team = sd.coding_code_id where t.project_info_id = '"
					+ projectInfoNo
					+ "' "
					+ " and (t.dev_type like 'S0803%' or t.dev_type like 'S0804%' or t.dev_type like 'S0806%' or t.dev_type like 'S0901%') "
					+ " group by substr(t.dev_type, 1, 5),t.dev_team,sd.coding_name ");
			sql.append(" union all ");
			sql.append(" select t.dev_team,sd.coding_name as excel_column_val0,'�׹�ըҩ��' as excel_column_val1,count(*) as excel_column_val2 "
					+ " from gms_device_account_dui t left join comm_coding_sort_detail sd on t.dev_team = sd.coding_code_id where t.project_info_id = '"
					+ projectInfoNo
					+ "' "
					+ " and t.dev_type like 'S08010304%' group by t.dev_team, sd.coding_name ");
			sql.append(" union all ");
			sql.append(" select t.dev_team,sd.coding_name as excel_column_val0,'��ˮ�޳�' as excel_column_val1,count(*) as excel_column_val2 "
					+ " from gms_device_account_dui t left join comm_coding_sort_detail sd on t.dev_team = sd.coding_code_id where t.project_info_id = '"
					+ projectInfoNo
					+ "' "
					+ " and (t.dev_type like 'S08010301%' or t.dev_type like 'S08010302%') group by t.dev_team, sd.coding_name ) t4 order by t4.dev_team");
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			// ��ȡ��Ŀ����
			String projectName = getProjectName(projectInfoNo, "����ӻ����豸�䱸ͳ��");
			String excelName = "����ӻ����豸�䱸ͳ��.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("����");
			headerList.add("�豸���");
			headerList.add("����");
			headerList.add("�ϼ�");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����ӻ����豸�䱸ͳ����ȡ��Ϣ
		if ("dzdzysbpbxx".equals(exportFlag)) {
			// �豸����
			String dev_types = msg.getValue("code");
			String[] codes = dev_types.split("~", -1);
			StringBuffer sql = new StringBuffer()
					.append("select dev_name as excel_column_val0,dev_model as excel_column_val1,license_num as excel_column_val4,self_num as excel_column_val2,dev_sign as excel_column_val3,asset_coding as excel_column_val5,")
					.append("oprtbl.operator_name as excel_column_val7,teamsd.coding_name as excel_column_val6 ")
					.append("from gms_device_account_dui dui ")
					.append("left join (select device_account_id,operator_name from ( ")
					.append("select tmp.device_account_id,tmp.operator_name,row_number() ")
					.append("over(partition by device_account_id order by length(operator_name) desc ) as seq ")
					.append("from (select device_account_id,wmsys.wm_concat(operator_name) ")
					.append("over(partition by device_account_id order by operator_name) as operator_name ")
					.append("from gms_device_equipment_operator where bsflag='0' ) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id ")
					.append("left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = dui.dev_team ")
					.append("where dui.project_info_id='" + projectInfoNo
							+ "' and dui.dev_team='" + codes[0] + "' ");
			if (codes[1].contains(",")) {
				String[] codeArray = codes[1].split(",");
				sql.append(" and (dev_type like 'S").append(codeArray[0])
						.append("%'");
				sql.append("      or dev_type like 'S").append(codeArray[1])
						.append("%')");
			} else {
				sql.append(" and dev_type like 'S").append(codes[1])
						.append("%'");
			}
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			// ��ȡ��Ŀ����
			String projectName = getProjectName(projectInfoNo,
					"����ӻ����豸�䱸ͳ����ȡ��Ϣ");
			String excelName = "����ӻ����豸�䱸ͳ����ȡ��Ϣ.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("AMIS�ʲ����");
			headerList.add("����");
			headerList.add("������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��Ҫ�豸�������ͳ�Ʊ���˾��
		if ("zysbjbqktjb".equals(exportFlag)) {
			// ������֯����
			String orgsubId = msg.getValue("orgsubId");
			StringBuilder sql = new StringBuilder(
					"select t.*,case when d.device_type is null then d.device_name else d.device_name||'('||d.device_type||')' end as device_name,"
							+ " case when d.dev_tree_id like 'D001%' then '��'  when d.dev_tree_id like 'D002%' or d.dev_tree_id like 'D003%'  then '̨'"
							+ " when d.dev_tree_id like 'D005%' then '��'  when d.dev_tree_id like 'D004%' or d.dev_tree_id like 'D006%'  then '��' end as unit"
							+ " from (select substr(dt.dev_tree_id, 1, 4) as device_code,"
							+ " sum(nvl(case when tdh.country='����' then tdh.sum_num end ,0)) as sum_num_in,"
							+ " sum(nvl(case when tdh.country='����' then tdh.sum_num end ,0)) as sum_num_out,"
							+ " sum(nvl(case when tdh.country='����' then tdh.use_num end,0)) as use_num_in,"
							+ " sum(nvl(case when tdh.country='����' then tdh.use_num end,0)) as use_num_out,"
							+ " sum(nvl(case when tdh.country='����' then tdh.idle_num end,0)) as idle_num_in,"
							+ " sum(nvl(case when tdh.country='����' then tdh.idle_num end,0)) as idle_num_out,"
							+ " sum(nvl(case when tdh.country='����' then tdh.repairing_num end,0)) as repairing_num_in,"
							+ " sum(nvl(case when tdh.country='����' then tdh.repairing_num end,0)) as repairing_num_out,"
							+ " sum(nvl(case when tdh.country='����' then tdh.wait_repair_num end,0)) as wait_repair_num_in,"
							+ " sum(nvl(case when tdh.country='����' then tdh.wait_repair_num end,0)) as wait_repair_num_out,"
							+ " sum(nvl(case when tdh.country='����' then tdh.wait_scrap_num end,0)) as wait_scrap_num_in,"
							+ " sum(nvl(case when tdh.country='����' then tdh.wait_scrap_num end,0)) as wait_scrap_num_out"
							+ " from dms_device_tree dt"
							+ " left join ( select * from gms_device_dailyhistory dh"
							+ " where dh.bsflag = '0' and dh.country in ('����','����')"
							+ " and dh.his_date=(select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");

			// ��̽��
			if (StringUtils.isNotBlank(orgsubId) && (!"C105".equals(orgsubId))) {
				sql.append(" and dh.org_subjection_id='" + orgsubId + "'");
			}
			sql.append(" ) tdh on tdh.device_type = dt.device_code where dt.bsflag='0'");
			sql.append(" group by substr(dt.dev_tree_id, 1,4)) t "
					+ "left join dms_device_tree d on t.device_code = d.dev_tree_id order by d.code_order");
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String orgName = getOrgName(orgsubId);
			String excelName = orgName + "��Ҫ�豸�������ͳ�Ʊ�.xls";
			String title = orgName + "��Ҫ�豸�������ͳ�Ʊ�";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸���");
			headerList.add("��λ");
			headerList.add("����/����");
			headerList.add("����");
			headerList.add("����");
			headerList.add("����");
			headerList.add("����");
			headerList.add("����");
			headerList.add("������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}

		// ����������ʧ���
		if ("dzyqssqk".equals(exportFlag)) {
			String orgsubid = msg.getValue("orgsubId");
			String sql = "select table1.project_name,table1.dev_name, table1.coll_name,table1.devtype,table1.seqnum,table1.totalnum,"
					+ "table1.sumcheck_num,table1.sumdestroy_num,nvl(table2.sumunuse_num,0) as sumunuse_num "
					+ "from "
					+ "(select firm.project_info_no,pro.project_name,parentci.dev_name,ci.dev_name as coll_name, sd.coding_name as devtype,"
					+ "sum(firm.tocheck_num) as sumcheck_num,sum(destroy_num) as sumdestroy_num,"
					+ "row_number() over(partition by project_name order by dev_name,coding_name) as seqnum,"
					+ "count(1) over(partition by project_name) as totalnum "
					+ "from gms_device_coll_account_firm firm "
					+ "left join gp_task_project pro on firm.project_info_no=pro.project_info_no "
					+ "left join gms_device_coll_account_dui colldui on firm.pro_dev_acc_id = colldui.dev_acc_id "
					+ "left join gms_device_collectinfo ci on colldui.device_id=ci.device_id "
					+ "left join gms_device_collectinfo parentci on ci.node_parent_id=parentci.device_id "
					+ "left join comm_coding_sort_detail sd on ci.node_type_id = sd.coding_code_id "
					+ "where parentci.dev_name is not null ";
			if (projectInfoNo != null && !"".equals(projectInfoNo)) {
				sql += "and firm.project_info_no ='" + projectInfoNo + "'";
			}
			sql += "group by firm.project_info_no,pro.project_name,parentci.dev_name,ci.dev_name,sd.coding_name ) table1 left join "
					+ "(select colldui2.project_info_id,parentci.dev_name,sd.coding_name,sum(colldui2.unuse_num) as  sumunuse_num  "
					+ "from gms_device_coll_account_dui colldui2  "
					+ "left join gms_device_collectinfo ci on colldui2.device_id = ci.device_id  "
					+ "left join gms_device_collectinfo parentci on ci.node_parent_id = parentci.device_id "
					+ "left join comm_coding_sort_detail sd on ci.node_type_id = sd.coding_code_id "
					+ "where parentci.dev_name is not null ";
			if (projectInfoNo != null && !"".equals(projectInfoNo)) {
				sql += "and colldui2.project_info_id ='" + projectInfoNo + "'";
			}
			sql += "group by colldui2.project_info_id,parentci.dev_name,sd.coding_name "
					+ ")table2 on table1.project_info_no=table2.project_info_id and table1.dev_name=table2.dev_name and table1.devtype=table2.coding_name "
					+ " where table1.dev_name is not null and (table1.sumcheck_num>0 or sumdestroy_num>0 or sumunuse_num>0) ";
			if (orgsubid != null && !"".equals(orgsubid)) {
				sql += "and exists(select 1 from gp_task_project_dynamic dym where dym.project_info_no=table1.project_info_no and dym.bsflag='0' "
						+ "and dym.project_info_no is not null and dym.org_subjection_id like '"
						+ orgsubid + "%' ) ";
			}
			sql += "order by table1.project_name,seqnum ";
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String excelName = "����������ʧ�����.xls";
			String title = "����������ʧ���";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("��Ŀ����");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�̿�����");
			headerList.add("��������");
			headerList.add("��������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ǿ�Ʊ����ƻ����б�
		if ("qzbyjhyxb".equals(exportFlag)) {
			String dateInfo = msg.getValue("dateinfo");
			String[] dateInfos = dateInfo.split("/");
			String dateinfo = dateInfos[0];
			int imonth = Integer.parseInt(dateInfos[1]);
			if (imonth < 10) {
				dateinfo += "-0" + imonth;
			} else {
				dateinfo += "-" + imonth;
			}
			String sql = "select t_info.*, t_date.* from (select t1.dev_acc_id,t1.dev_name as excel_column_val0,t1.dev_model as excel_column_val1,t1.license_num as excel_column_val2, "
					+ " t1.dev_type,t2.plan_date,t1.self_num as excel_column_val3,t1.dev_sign as excel_column_val4,oprtbl.alloprinfo as excel_column_val5 "
					+ " from (select dui.dev_acc_id,dui.dev_name,dui.dev_model,dui.license_num,dui.dev_type,dui.self_num,dui.dev_sign from gms_device_account_dui dui "
					+ "  where (substr(dui.dev_type, 2, 6) = '070301' or substr(dui.dev_type, 2, 2) = '08' or substr(dev_type, 2, 4) = '0901' or substr(dui.dev_type, 2, 4) = '0601' or "
					+ " substr(dui.dev_type, 2, 4) = '0622' or substr(dui.dev_type, 2, 4) = '0623' or substr(dui.dev_type, 2, 4) = '0703')and dui.bsflag = '0' "
					+ " and dui.project_info_id ='"
					+ projectInfoNo
					+ "') t1 "
					+ " left join (select * from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id) as alloprinfo from gms_device_equipment_operator where bsflag='0' ) a "
					+ " group by a.device_account_id, a.alloprinfo) oprtbl on t1.dev_acc_id = oprtbl.device_account_id left join (select plan1.dev_acc_id, plan1.plan_date "
					+ " from gms_device_maintenance_plan plan1 where plan1.plan_date = (select min(plan2.plan_date) from gms_device_maintenance_plan plan2 where plan2.dev_acc_id = plan1.dev_acc_id)) t2 "
					+ " on t2.dev_acc_id = t1.dev_acc_id order by t1.dev_type, t2.plan_date) t_info left join (select dui.dev_acc_id,to_char(p.plan_date, 'yyyy-MM-dd') as excel_column_val6,to_char(r.repair_start_date, 'yyyy-MM-dd') as excel_column_val7 "
					+ " from gms_device_account_dui dui left join gms_device_maintenance_plan p on dui.dev_acc_id = p.dev_acc_id left join bgp_comm_device_repair_info r "
					+ " on dui.dev_acc_id = r.device_account_id and r.repair_level = '605' where dui.bsflag = '0' "
					+ " and dui.project_info_id = '"
					+ projectInfoNo
					+ "' "
					+ " and ( substr(to_char(p.plan_date, 'yyyy-MM-dd'), 1, 7) = '"
					+ dateinfo
					+ "' or substr(to_char(r.repair_start_date, 'yyyy-MM-dd'), 1, 7) = '"
					+ dateinfo
					+ "') ) t_date on t_info.dev_acc_id = t_date.dev_acc_id order by t_info.dev_type, t_info.plan_date,t_info.dev_acc_id,t_date.excel_column_val6,t_date.excel_column_val7";
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String projectName = getProjectName(projectInfoNo, "ǿ�Ʊ����ƻ����б�");
			String excelName = "ǿ�Ʊ����ƻ����б�.xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("�豸�ͺ�");
			headerList.add("���պ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// �豸����ȼ������ͳ��
		if ("sbdjryxhtj".equals(exportFlag)) {
			String sql = "select '�ɿ���Դ' excel_column_val0, project_info_id , sum(oil_total) as excel_column_val1"
					+ " from (select b.project_info_id, a.oil_total"
					+ " from bgp_comm_device_oil_info a"
					+ " left join gms_device_account_dui b on a.device_account_id ="
					+ " b.dev_acc_id"
					+ " left join gp_task_project c on b.project_info_id ="
					+ " c.project_info_no"
					+ " where a.bsflag = '0'"
					+ " and b.project_info_id = '8ad88271492e5492014930939ea214e2'"
					+ " and b.dev_type like 'S062301%'"
					+ " and a.oil_name in ('0110000043000000001', '0110000043000000002')"
					+ " union"
					+ " select t.project_info_no, d.total_money"
					+ " from gms_mat_teammat_out t"
					+ " inner join GMS_MAT_TEAMMAT_OUT_DETAIL d"
					+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id on"
					+ " t.teammat_out_id ="
					+ " d.teammat_out_id"
					+ " left join gp_task_project pro on t.project_info_no ="
					+ " pro.project_info_no"
					+ " left join gms_device_account_dui dui on d.dev_acc_id ="
					+ " dui.dev_acc_id"
					+ " where t.out_type = '3'"
					+ " and t.project_info_no = '"
					+ projectInfoNo
					+ "'"
					+ " and dui.dev_type like 'S062301%') tmp1"
					+ " group by project_info_id"
					+ " union all"
					+ " select '������' deviceType, project_info_id, sum(oil_total) as oiltota"
					+ " from (select b.project_info_id, a.oil_total"
					+ " from bgp_comm_device_oil_info a"
					+ " left join gms_device_account_dui b on a.device_account_id ="
					+ " b.dev_acc_id"
					+ " left join gp_task_project c on b.project_info_id ="
					+ " c.project_info_no"
					+ " where a.bsflag = '0'"
					+ " and b.project_info_id = '"
					+ projectInfoNo
					+ "'"
					+ " and b.dev_type like 'S070301%'"
					+ " and a.oil_name in ('0110000043000000001', '0110000043000000002')"
					+ " union"
					+ " select t.project_info_no, d.total_money"
					+ " from gms_mat_teammat_out t"
					+ " inner join GMS_MAT_TEAMMAT_OUT_DETAIL d"
					+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id on"
					+ " t.teammat_out_id ="
					+ " d.teammat_out_id"
					+ " left join gp_task_project pro on t.project_info_no ="
					+ " pro.project_info_no"
					+ " left join gms_device_account_dui dui on d.dev_acc_id ="
					+ " dui.dev_acc_id"
					+ " where t.out_type = '3'"
					+ " and t.project_info_no = '"
					+ projectInfoNo
					+ "'"
					+ " and dui.dev_type like 'S070301%') tmp1"
					+ " group by project_info_id"
					+ " union all"
					+ " select '�����豸' deviceType, project_info_id, sum(oil_total) as oiltot"
					+ " from (select b.project_info_id, a.oil_total"
					+ " from bgp_comm_device_oil_info a"
					+ " left join gms_device_account_dui b on a.device_account_id ="
					+ " b.dev_acc_id"
					+ " left join gp_task_project c on b.project_info_id ="
					+ " c.project_info_no"
					+ " where a.bsflag = '0'"
					+ " and b.project_info_id = '"
					+ projectInfoNo
					+ "'"
					+ " and b.dev_type like 'S08%'"
					+ " and a.oil_name in ('0110000043000000001', '0110000043000000002')"
					+ " union"
					+ " select t.project_info_no, d.total_money"
					+ " from gms_mat_teammat_out t"
					+ " inner join GMS_MAT_TEAMMAT_OUT_DETAIL d"
					+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id on"
					+ " t.teammat_out_id ="
					+ " d.teammat_out_id"
					+ " left join gp_task_project pro on t.project_info_no ="
					+ " pro.project_info_no"
					+ " left join gms_device_account_dui dui on d.dev_acc_id ="
					+ " dui.dev_acc_id"
					+ " where t.out_type = '3'"
					+ " and t.project_info_no = '"
					+ projectInfoNo
					+ "'"
					+ " and dui.dev_type like 'S08%') tmp1"
					+ " group by project_info_id"
					+ " union all"
					+ " select '�������' deviceType, project_info_id, sum(oil_total) as oiltot"
					+ " from (select b.project_info_id, a.oil_total"
					+ " from bgp_comm_device_oil_info a"
					+ " left join gms_device_account_dui b on a.device_account_id ="
					+ " b.dev_acc_id"
					+ " left join gp_task_project c on b.project_info_id ="
					+ " c.project_info_no"
					+ " where a.bsflag = '0'"
					+ " and b.project_info_id = '"
					+ projectInfoNo
					+ "'"
					+ " and b.dev_type like 'S0901%'"
					+ " and a.oil_name in ('0110000043000000001', '0110000043000000002')"
					+ " union"
					+ " select t.project_info_no, d.total_money"
					+ " from gms_mat_teammat_out t"
					+ " inner join GMS_MAT_TEAMMAT_OUT_DETAIL d"
					+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id on"
					+ " t.teammat_out_id ="
					+ " d.teammat_out_id"
					+ " left join gp_task_project pro on t.project_info_no ="
					+ " pro.project_info_no"
					+ " left join gms_device_account_dui dui on d.dev_acc_id ="
					+ " dui.dev_acc_id"
					+ " where t.out_type = '3'"
					+ " and t.project_info_no = '"
					+ projectInfoNo
					+ "'"
					+ " and dui.dev_type like 'S0901%') tmp1"
					+ " group by project_info_id"
					+ " union all"
					+ " select 'Ħ�г�' deviceType, project_info_id, sum(oil_total) as oiltota"
					+ " from (select b.project_info_id, a.oil_total"
					+ " from bgp_comm_device_oil_info a"
					+ " left join gms_device_account_dui b on a.device_account_id ="
					+ " b.dev_acc_id"
					+ " left join gp_task_project c on b.project_info_id ="
					+ " c.project_info_no"
					+ " where a.bsflag = '0'"
					+ " and b.project_info_id = '"
					+ projectInfoNo
					+ "'"
					+ " and b.dev_type like 'S0805%'"
					+ " and a.oil_name in ('0110000043000000001', '0110000043000000002')"
					+ " union"
					+ " select t.project_info_no, d.total_money"
					+ " from gms_mat_teammat_out t"
					+ " inner join GMS_MAT_TEAMMAT_OUT_DETAIL d"
					+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id on"
					+ " t.teammat_out_id ="
					+ " d.teammat_out_id"
					+ " left join gp_task_project pro on t.project_info_no ="
					+ " pro.project_info_no"
					+ " left join gms_device_account_dui dui on d.dev_acc_id ="
					+ " dui.dev_acc_id"
					+ " where t.out_type = '3'"
					+ " and t.project_info_no = '"
					+ projectInfoNo
					+ "'"
					+ " and dui.dev_type like 'S0805%') tmp1"
					+ " group by project_info_id"
					+ " union all"
					+ " select '��̧�����' deviceType, project_info_id, sum(oil_total) as oilto"
					+ " from (select b.project_info_id, a.oil_total"
					+ " from bgp_comm_device_oil_info a"
					+ " left join gms_device_account_dui b on a.device_account_id ="
					+ " b.dev_acc_id"
					+ " left join gp_task_project c on b.project_info_id ="
					+ " c.project_info_no"
					+ " where a.bsflag = '0'"
					+ " and b.project_info_id = '"
					+ projectInfoNo
					+ "'"
					+ " and b.dev_type like 'S060102%'"
					+ " and a.oil_name in ('0110000043000000001', '0110000043000000002')"
					+ " union"
					+ " select t.project_info_no, d.total_money"
					+ " from gms_mat_teammat_out t"
					+ " inner join GMS_MAT_TEAMMAT_OUT_DETAIL d"
					+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id on"
					+ " t.teammat_out_id ="
					+ " d.teammat_out_id"
					+ " left join gp_task_project pro on t.project_info_no ="
					+ " pro.project_info_no"
					+ " left join gms_device_account_dui dui on d.dev_acc_id ="
					+ " dui.dev_acc_id"
					+ " where t.out_type = '3'"
					+ " and t.project_info_no = '"
					+ projectInfoNo
					+ "'"
					+ " and dui.dev_type like 'S060102%') tmp1"
					+ " group by project_info_id"
					+ " union all"
					+ " select '��װ���' deviceType, project_info_id, sum(oil_total) as oiltot"
					+ " from (select b.project_info_id, a.oil_total"
					+ " from bgp_comm_device_oil_info a"
					+ " left join gms_device_account_dui b on a.device_account_id ="
					+ " b.dev_acc_id"
					+ " left join gp_task_project c on b.project_info_id ="
					+ " c.project_info_no"
					+ " where a.bsflag = '0'"
					+ " and b.project_info_id = '"
					+ projectInfoNo
					+ "'"
					+ " and b.dev_type like 'S060101%'"
					+ " and a.oil_name in ('0110000043000000001', '0110000043000000002')"
					+ " union"
					+ " select t.project_info_no, d.total_money"
					+ " from gms_mat_teammat_out t"
					+ " inner join GMS_MAT_TEAMMAT_OUT_DETAIL d"
					+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id on"
					+ " t.teammat_out_id ="
					+ " d.teammat_out_id"
					+ " left join gp_task_project pro on t.project_info_no ="
					+ " pro.project_info_no"
					+ " left join gms_device_account_dui dui on d.dev_acc_id ="
					+ " dui.dev_acc_id"
					+ " where t.out_type = '3'"
					+ " and t.project_info_no = '"
					+ projectInfoNo
					+ "'"
					+ " and dui.dev_type like 'S060101%') tmp1"
					+ " group by project_info_id";
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String excelName = "�豸����ȼ������ͳ��.xls";
			String title = getProjectName(projectInfoNo, "�豸����ȼ������ͳ��");
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("�豸����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// �豸����ȼ��������ϸ
		if ("sbdjryxhmx".equals(exportFlag)) {
			// �豸���ͱ���
			String code = msg.getValue("code");
			String sql = "select dev_name as excel_column_val0,dev_model as excel_column_val1,license_num as excel_column_val4,self_num as excel_column_val2,dev_sign as excel_column_val3,sum(oil_total) as excel_column_val5,sum(oil_quantity) as excel_column_val6 from ("
					+ "select tmp1.*,sum(oil_quantity) over(order by fill_date) as oil_sum_quantity, "
					+ "sum(oil_total) over(order by fill_date) as oil_sum_total "
					+ "from "
					+ "  (select b.dev_name,b.dev_model,b.license_num,b.self_num,b.dev_sign, "
					+ "	(select coding_name from comm_coding_sort_detail where coding_code_id=a.OIL_NAME)as OIL_NAME1,"
					+ "   (select coding_name from comm_coding_sort_detail where coding_code_id=a.OIL_MODEL)as OIL_MODEL1,"
					+ "   b.owning_org_name,c.project_name,a.oil_info_id,a.device_account_id,a.fill_date,"
					+ "   a.oil_unit,a.oil_quantity,a.oil_unit_price,a.oil_total,'false' as checktype "
					+ "   from bgp_comm_device_oil_info a "
					+ "   left join gms_device_account_dui b on a.device_account_id=b.dev_acc_id "
					+ "   left join gp_task_project c on b.project_info_id=c.project_info_no "
					+ "   where a.bsflag='0' and b.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "    and b.dev_type like 'S"
					+ code
					+ "%' and a.oil_name in ('0110000043000000001','0110000043000000002') "
					+ "    union "
					+ "   select dui.dev_name,dui.dev_model,dui.license_num,dui.self_num,dui.dev_sign ,"
					+ "    i.wz_name as oil_name1,'' as oil_model1,t.org_id as owning_org_name,"
					+ "    pro.project_name,t.teammat_out_id as oil_info_id,t.dev_acc_id as device_account_id,t.outmat_date as fill_date,"
					+ "    i.wz_prickie,d.oil_num, d.actual_price,d.total_money,'true' as checktype "
					+ "    from gms_mat_teammat_out t "
					+ "    inner join GMS_MAT_TEAMMAT_OUT_DETAIL d "
					+ "    inner join gms_mat_infomation i on d.wz_id=i.wz_id on t.teammat_out_id = d.teammat_out_id "
					+ "    left join gp_task_project pro on t.project_info_no=pro.project_info_no "
					+ "     left join gms_device_account_dui dui on d.dev_acc_id=dui.dev_acc_id "
					+ "    where t.out_type='3' and t.project_info_no='"
					+ projectInfoNo
					+ "' "
					+ "   and dui.dev_type like 'S"
					+ code
					+ "%') "
					+ "   tmp1 "
					+ ") group by dev_name,dev_model,license_num,self_num,dev_sign order by dev_name,dev_model,license_num,self_num,dev_sign";
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String excelName = "�豸����ȼ��������ϸ.xls";
			String title = getProjectName(projectInfoNo, "�豸����ȼ��������ϸ");
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("ȼ�����Ľ��");
			headerList.add("����������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}

		// �豸������������ͳ��
		if ("sbdjclxhtj".equals(exportFlag)) {
			String sql = "select label as dev_type,name as excel_column_val0, sum(devnum) as excel_column_val1,nvl(sum(total_charge),0) as excel_column_val2 from"
					+ "(select '08' as label,'�����豸' as name,dui.dev_type,temp.devnum, temp.total_charge from ( "
					+ "(select count(distinct device_account_id) as devnum, "
					+ "info.device_account_id,sum(det.total_charge) as total_charge from BGP_COMM_DEVICE_REPAIR_INFO info "
					+ "left join bgp_comm_device_repair_detail det on info.repair_info=det.repair_info "
					+ "group by info.device_account_id) temp "
					+ "join gms_device_account_dui dui on dui.dev_acc_id=temp.device_account_id) "
					+ "where temp.total_charge is not null and dui.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "and dui.dev_type like 'S08%' and dui.dev_type not like 'S0805%') "
					+ "group by label,name  union all "

					+ "select label as dev_type,name as excel_column_val0, sum(devnum) as excel_column_val1,nvl(sum(total_charge),0) as excel_column_val2 from"
					+ "(select '070301' as label,'������' as name,dui.dev_type,temp.devnum, temp.total_charge from ( "
					+ "(select count(distinct device_account_id) as devnum, "
					+ "info.device_account_id,sum(det.total_charge) as total_charge from bgp_comm_device_repair_info info "
					+ "left join bgp_comm_device_repair_detail det on info.repair_info=det.repair_info "
					+ "group by info.device_account_id) temp "
					+ "join gms_device_account_dui dui on dui.dev_acc_id=temp.device_account_id) "
					+ "where temp.total_charge is not null and dui.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "and dui.dev_type like 'S070301%' ) "
					+ "group by label,name  union all "

					+ "select label as dev_type,name as excel_column_val0, sum(devnum) as excel_column_val1,nvl(sum(total_charge),0) as excel_column_val2 from"
					+ "(select '0901' as label,'�������' as name,dui.dev_type,temp.devnum, temp.total_charge from ( "
					+ "(select count(distinct device_account_id) as devnum, "
					+ "info.device_account_id,sum(det.total_charge) as total_charge from bgp_comm_device_repair_info info "
					+ "left join bgp_comm_device_repair_detail det on info.repair_info=det.repair_info "
					+ "group by info.device_account_id) temp "
					+ "join gms_device_account_dui dui on dui.dev_acc_id=temp.device_account_id) "
					+ "where temp.total_charge is not null and dui.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "and dui.dev_type like 'S0901%' ) "
					+ "group by label,name  union all "

					+ "select label as dev_type,name as excel_column_val0, sum(devnum) as excel_column_val1,nvl(sum(total_charge),0) as excel_column_val2 from"
					+ "(select '0805' as label,'Ħ�г�' as name,dui.dev_type,temp.devnum, temp.total_charge from ( "
					+ "(select count(distinct device_account_id) as devnum, "
					+ "info.device_account_id,sum(det.total_charge) as total_charge from bgp_comm_device_repair_info info "
					+ "left join bgp_comm_device_repair_detail det on info.repair_info=det.repair_info "
					+ "group by info.device_account_id) temp "
					+ "join gms_device_account_dui dui on dui.dev_acc_id=temp.device_account_id) "
					+ "where temp.total_charge is not null and dui.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "and dui.dev_type like 'S0805%' ) "
					+ "group by label,name  union all "

					+ "select label as dev_type,name as excel_column_val0, sum(devnum) as excel_column_val1,nvl(sum(total_charge),0) as excel_column_val2 from"
					+ "(select '060101' as label,'	' as name,dui.dev_type,temp.devnum, temp.total_charge from ( "
					+ "(select count(distinct device_account_id) as devnum, "
					+ "info.device_account_id,sum(det.total_charge) as total_charge from bgp_comm_device_repair_info info "
					+ "left join bgp_comm_device_repair_detail det on info.repair_info=det.repair_info "
					+ "group by info.device_account_id) temp "
					+ "join gms_device_account_dui dui on dui.dev_acc_id=temp.device_account_id) "
					+ "where temp.total_charge is not null and dui.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "and dui.dev_type like 'S060101%' ) "
					+ "group by label,name  union all  "

					+ "select label as dev_type,name as excel_column_val0, sum(devnum) as excel_column_val1,nvl(sum(total_charge),0) as excel_column_val2 from"
					+ "(select '060102' as label,'��̧�����' as name,dui.dev_type,temp.devnum, temp.total_charge from ( "
					+ "(select count(distinct device_account_id) as devnum, "
					+ "info.device_account_id,sum(det.total_charge) as total_charge from bgp_comm_device_repair_info info "
					+ "left join bgp_comm_device_repair_detail det on info.repair_info=det.repair_info "
					+ "group by info.device_account_id) temp "
					+ "join gms_device_account_dui dui on dui.dev_acc_id=temp.device_account_id) "
					+ "where temp.total_charge is not null and dui.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "and dui.dev_type like 'S060102%' ) "
					+ "group by label,name ";
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String excelName = "�豸������������ͳ��.xls";
			String title = getProjectName(projectInfoNo, "�豸������������ͳ��");
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("̨��");
			headerList.add("���Ľ���λ:Ԫ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��������������ȡ��Ϣ-һ����ȡ(�豸����)
		if ("sbdjclxhzqxx1".equals(exportFlag)) {
			// �豸���ͱ���
			String devtype = msg.getValue("code");
			String sql = "";
			if (devtype.equals("08")) {
				sql = "select dui.license_num as excel_column_val4,dui.self_num as excel_column_val2,dui.dev_sign  as excel_column_val3,dui.dev_name as excel_column_val0,dui.dev_model as excel_column_val1, temp.total_charge as excel_column_val5,temp.device_account_id  from ( "
						+ "(select info.device_account_id,sum(det.total_charge) as total_charge  from bgp_comm_device_repair_info info "
						+ "left join bgp_comm_device_repair_detail det on info.repair_info=det.repair_info "
						+ "group by info.device_account_id) temp "
						+ "join gms_device_account_dui dui on dui.dev_acc_id=temp.device_account_id) "
						+ "where  temp.total_charge is not null and dui.project_info_id='"
						+ projectInfoNo
						+ "' "
						+ "and dui.dev_type like 'S"
						+ devtype + "%' and dui.dev_type not like 'S0805%'";
			} else {
				sql = "select dui.license_num as excel_column_val4,dui.self_num as excel_column_val2,dui.dev_sign as excel_column_val3,dui.dev_name as excel_column_val0,dui.dev_model as excel_column_val1, temp.total_charge as excel_column_val5,temp.device_account_id from ( "
						+ "(select info.device_account_id,sum(det.total_charge) as total_charge  from bgp_comm_device_repair_info info "
						+ "left join bgp_comm_device_repair_detail det on info.repair_info=det.repair_info "
						+ "group by info.device_account_id) temp "
						+ "join gms_device_account_dui dui on dui.dev_acc_id=temp.device_account_id) "
						+ "where temp.total_charge is not null and dui.project_info_id='"
						+ projectInfoNo
						+ "' "
						+ "and dui.dev_type like 'S"
						+ devtype + "%'";
			}
			String devName = "";
			if ("08".equals(devtype)) {
				devName = "�����豸";
			}
			if ("070301".equals(devtype)) {
				devName = "������";
			}
			if ("0901".equals(devtype)) {
				devName = "�������";
			}
			if ("0805".equals(devtype)) {
				devName = "Ħ�г�";
			}
			if ("060101".equals(devtype)) {
				devName = "��װ���";
			}
			if ("060102".equals(devtype)) {
				devName = "��̧�����";
			}
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String excelName = "�豸��������������Ϣ(" + devName + ").xls";
			String title = getProjectName(projectInfoNo, "�豸��������������Ϣ");
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("�������Ľ��(��λ��Ԫ)");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��������������ȡ��Ϣ-������ȡ(�豸��Ϣ)
		if ("sbdjclxhzqxx2".equals(exportFlag)) {
			String repair_info = msg.getValue("repair_info");
			String sql = "select dui.dev_name        as excel_column_val0,dui.dev_model       as excel_column_val1, dui.license_num     as excel_column_val2, dui.self_num        as excel_column_val3,dui.dev_sign        as excel_column_val4,det.coding_name        as excel_column_val5,"
					+ " ope.operator_name    as excel_column_val6,"
					+ " d.material_name     as excel_column_val7,"
					+ " i.wz_prickie      as excel_column_val8,"
					+ " d.material_amout   as excel_column_val9,"
					+ " d.unit_price        as excel_column_val10,"
					+ " d.total_charge      as excel_column_val11,"
					+ " t.creator           as excel_column_val12,"
					+ "t.repair_detail     as excel_column_val13,"
					+ "t.repair_start_date as excel_column_val14,"
					+ "t.repair_end_date   as excel_column_val15  from bgp_comm_device_repair_info"
					+ " t left join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id left join comm_coding_sort_detail det on dui.dev_team=det.coding_code_id left join GMS_DEVICE_EQUIPMENT_OPERATOR ope on t.device_account_id=ope.device_account_id left join bgp_comm_device_repair_detail d on t.repair_info=d.repair_info left join gms_mat_infomation i on d.material_coding=i.wz_id where t.device_account_id='"
					+ repair_info + "' order by t.repair_end_date desc";
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String excelName = "�豸��������������Ϣ.xls";
			String title = getProjectName(projectInfoNo, "�豸��������������Ϣ");
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("���պ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("����");
			headerList.add("������");
			headerList.add("��������");
			headerList.add("������λ");
			headerList.add("ʹ������");
			headerList.add("����");
			headerList.add("���");
			headerList.add("���");
			headerList.add("ά�ޱ�ע");
			headerList.add("ά�޿�ʼʱ��");
			headerList.add("ά�޽���ʱ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}

		// �ֳ�ά�޷���ͳ��
		if ("xcwxfytj".equals(exportFlag)) {
			String sql = "select coding_code_id,coding_name as excel_column_val0 ,total_charge as excel_column_val1 from "
					+ "((select code.coding_name,code.coding_code,code.coding_code_id,"
					+ "nvl(sum(tmp.total_charge),0) as total_charge,'1' as seq "
					+ "from comm_coding_sort_detail code "
					+ "left join "
					+ "(select rep.repair_info,rep.repair_item,sum(det.total_charge) as total_charge "
					+ "from bgp_comm_device_repair_info rep "
					+ "left join bgp_comm_device_repair_detail det on det.repair_info=rep.repair_info "
					+ "left join gms_device_account_dui dui on dui.dev_acc_id=rep.device_account_id "
					+ "and dui.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "where det.total_charge>0 and dui.dev_acc_id is not null "
					+ "group by rep.repair_info,rep.repair_item) tmp on code.coding_code_id=tmp.repair_item "
					+ "where code.coding_sort_id='5110000024' and code.coding_code_id!='019'"
					+ "group by code.coding_name,coding_code,code.coding_code_id ) "
					+ "union all "
					+ "(select code.coding_name,code.coding_code,code.coding_code_id,"
					+ "(select sum(total_charge) from "
					+ "(select '019' as coding_code_id,oil.oil_total as total_charge "
					+ "from bgp_comm_device_oil_info oil "
					+ "left join gms_device_account_dui dui on dui.dev_acc_id=oil.device_account_id "
					+ "and dui.project_info_id='"
					+ projectInfoNo
					+ "' "
					+ "where oil.oil_total>0 and dui.dev_acc_id is not null) tmp group by tmp.coding_code_id ) as total_charge,"
					+ "'2' as seq "
					+ "from comm_coding_sort_detail code "
					+ "where code.coding_code_id='019' and code.bsflag='0' ) "
					+ ")data1 order by data1.seq,data1.coding_code";
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			String excelName = "�ֳ�ά�޷���ͳ��.xls";
			String title = getProjectName(projectInfoNo, "�ֳ�ά�޷���ͳ��");
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸ά������");
			headerList.add("ά�޷��ã���λ:Ԫ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��е�豸����ͳ�Ʊ�
		if ("jxsbpztjb".equals(exportFlag)) {
			String sql = "select '��װ���' as dev_name,t.dev_model,'̨' as dev_unit,count(*) numb "
					+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S060101%' and t.project_info_id = '"
					+ projectInfoNo
					+ "' group by t.dev_model "
					+ " union all "
					+ " select 'ɽ�����' as dev_name,t.dev_model,'��' as dev_unit,count(*) numb "
					+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S060102%' and t.project_info_id = '"
					+ projectInfoNo
					+ "' group by t.dev_model "
					+ " union all "
					+ " select '���ճ�' as dev_name,t.dev_model,'��' as dev_unit,count(*) numb "
					+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S080304%' and t.project_info_id = '"
					+ projectInfoNo
					+ "' group by t.dev_model "
					+ " union all "
					+ " select '��ͨ����' as dev_name,t.dev_model,'��' as dev_unit,count(*) numb "
					+ " from gms_device_account_dui t where t.bsflag = '0'  and t.dev_type in ('S0801010002011','S0801010002037','S0801010002009','S0801010002015','S0801010002030','S0801010002013', "
					+ " 'S0801010099021','S0801010002004','S0801010007020','S0801010002010','S0801010004004','S0801010002040','S0801010002050','S0801010001003','S0801010001004','S0801010002037', "
					+ " 'S0801010002042','S0801010008004','S0801010009003','S0801010002018','S0801010002032','S0801010002014') "
					+ " and t.project_info_id = '"
					+ projectInfoNo
					+ "' group by t.dev_model "
					+ " union all "
					+ " select 'ɳĮ����' as dev_name,t.dev_model,'��' as dev_unit,count(*) numb "
					+ " from gms_device_account_dui t where t.bsflag = '0'  and t.dev_type in ('S0801010002035','S0801010007006','S0801010006004','S0801010007007','S0801010002036', "
					+ " 'S0801010002047','S0801010002035','S0801010002038','S0801010002046','S0801010010007','S0801010010005','S0801010010009','S0801010006004','S0801010002039', "
					+ " 'S0801010010008','S0801010010002','S0801010010001','S0801010002045','S0801010010001','S0801010002038','S0801010002045','S0801010002041','S0801010010003', "
					+ " 'S0801010011009','S0801010011005','S0801010010012','S0801010002048','S0801010010006','S0801010010009','S0801010010013','S0801010002044','S0801010002048', "
					+ " 'S0801010007013','S0801010007007','S0801010006006','S0801010007008','S0801010007010') "
					+ " and t.project_info_id = '"
					+ projectInfoNo
					+ "' group by t.dev_model "
					+ " union all "
					+ " select '�׹�ըҩ��' as dev_name,t.dev_model,'��' as dev_unit,count(*) numb "
					+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S08010304%' "
					+ " and t.project_info_id = '"
					+ projectInfoNo
					+ "' group by t.dev_model "
					+ " union all "
					+ " select '��ˮ�೵' as dev_name,t.dev_model,'��' as dev_unit,count(*) numb "
					+ " from gms_device_account_dui t where t.bsflag = '0' and (t.dev_type like 'S08010301%' or t.dev_type like 'S08010302%') "
					+ " and t.project_info_id = '"
					+ projectInfoNo
					+ "' group by t.dev_model "
					+ " union all "
					+ " select '������' as dev_name,t.dev_model,'��' as dev_unit,count(*) numb "
					+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S070301%' "
					+ " and t.project_info_id = '"
					+ projectInfoNo
					+ "' group by t.dev_model "
					+ " union all "
					+ " SELECT '��������' as dev_name,T.DEV_MODEL,'��' as dev_unit,SUM(nvl(T.TOTAL_NUM, 0) * nvl(T2.DEVICE_SLOT_NUM, 0)) as numb "
					+ " FROM GMS_DEVICE_COLL_ACCOUNT_dui T LEFT JOIN GMS_DEVICE_COLLECTINFO T1 ON T1.DEVICE_ID = T.DEVICE_ID "
					+ " LEFT JOIN GMS_DEVICE_COLLMODEL_SUB T2 ON T2.DEVICE_ID = T.DEVICE_ID WHERE (T1.DEV_CODE LIKE '01%' OR T1.DEV_CODE LIKE '02%' OR T1.DEV_CODE LIKE '03%') "
					+ " and t.project_info_id = '"
					+ projectInfoNo
					+ "' GROUP BY T.DEV_MODEL "
					+ " union all "
					+ " SELECT '�첨��' as dev_name,T.DEV_MODEL,'��' as dev_unit,sum(nvl(T.TOTAL_NUM, 0)) as numb "
					+ " FROM GMS_DEVICE_COLL_ACCOUNT_dui T LEFT JOIN GMS_DEVICE_COLLECTINFO T1 ON T1.DEVICE_ID = T.DEVICE_ID "
					+ " WHERE T1.DEV_CODE LIKE '04%' and t.project_info_id = '"
					+ projectInfoNo + "'  GROUP BY T.DEV_MODEL ";
			List<Map> list = jdbcDao.queryRecords(sql);
			String excelName = "��е�豸����ͳ�Ʊ�.xls";
			// ��ȡ��Ŀ����
			String projectName = getProjectName(projectInfoNo, "��е�豸����ͳ�Ʊ�");
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("����");
			headerList.add("����ͺ�");
			headerList.add("������λ");
			headerList.add("����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// �ֳ�ά��ά�޷���ͳ��--��̽����
		if ("xcwxfytjwutanchu".equals(exportFlag)) {
			String orgsubId = msg.getValue("orgsubId");
			String proYear = msg.getValue("proYear");
			String sql = "select coding_code_id,coding_name as excel_column_val0,total_charge as excel_column_val1  from "
					+ "((select code.coding_name,code.coding_code,code.coding_code_id,"
					+ "nvl(sum(tmp.total_charge),0) as total_charge,'1' as seq "
					+ "from comm_coding_sort_detail code "
					+ "left join "
					+ "(select rep.repair_info,rep.repair_item,sum(det.total_charge) as total_charge "
					+ "from bgp_comm_device_repair_info rep "
					+ "left join bgp_comm_device_repair_detail det on det.repair_info=rep.repair_info "
					+ "left join gms_device_account_dui dui on dui.dev_acc_id=rep.device_account_id "
					+ "left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' "
					+ "where dui.project_info_id is not null and dym.org_subjection_id like '"
					+ orgsubId
					+ "%'"
					+ "and rep.repair_end_date is not null "
					+ "and substr(to_char(rep.repair_end_date,'yyyy-mm-dd'),1,4)='"
					+ proYear
					+ "' "
					+ "and det.total_charge>0 and dui.dev_acc_id is not null "
					+ "group by rep.repair_info,rep.repair_item) tmp on code.coding_code_id=tmp.repair_item "
					+ "where code.coding_sort_id='5110000024' and code.coding_code_id!='019'"
					+ "group by code.coding_name,coding_code,code.coding_code_id ) "
					+ "union all "
					+ "(select code.coding_name,code.coding_code,code.coding_code_id,"
					+ "nvl((select sum(total_charge) from "
					+ "(select '019' as coding_code_id,oil.oil_total as total_charge "
					+ "from bgp_comm_device_oil_info oil "
					+ "left join gms_device_account_dui dui on dui.dev_acc_id=oil.device_account_id "
					+ "left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' "
					+ "where dui.project_info_id is not null and dym.org_subjection_id like '"
					+ orgsubId
					+ "%'"
					+ "and oil.fill_date is not null "
					+ "and substr(to_char(oil.fill_date,'yyyy-mm-dd'),1,4)='"
					+ proYear
					+ "' "
					+ "and oil.oil_total>0 and dui.dev_acc_id is not null) tmp group by tmp.coding_code_id ),0) as total_charge,"
					+ "'2' as seq "
					+ "from comm_coding_sort_detail code "
					+ "where code.coding_code_id='019' and code.bsflag='0' ) "
					+ ")data1 order by data1.seq,data1.coding_code";
			List<Map> list = jdbcDao.queryRecords(sql);
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "�ֳ�ά�޷���ͳ��.xls";
			String title = proYear + "���" + orgName + "�ֳ�ά�޷���ͳ��";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸ά������");
			headerList.add("ά�޷��ã���λ:Ԫ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		//��������ͳ��
		if("bjxhtj".equals(exportFlag)){
			//��ȡ��ǰ���
			Calendar cal = Calendar.getInstance();
			Integer year = cal.get(Calendar.YEAR);
			String currentYear=year.toString();
			//��ȡ��ǰʱ��
			Date now = new Date();
			SimpleDateFormat dateFormat = new SimpleDateFormat(
					"yyyy-MM-dd");
			String currentDate=dateFormat.format(now);
			String matCode = msg.getValue("matCode");//  �������
			String orgSubId = msg.getValue("orgSubId");// ��̽��
			// ��ʼʱ��
			String startDate = msg.getValue("startDate");
			// ����ʱ��
			String endDate = msg.getValue("endDate");
			String _startDate="";
			String _endDate="";
			if(StringUtils.isNotBlank(startDate)){
				_startDate=startDate;
			}else{
				_startDate=(currentYear+"-01-01").trim();
			}
			if(StringUtils.isNotBlank(endDate)){
				_endDate=endDate;
			}else{
				_endDate=currentDate;
			}
			StringBuilder sql = new StringBuilder(
					"select t.mat_code,t.mat_name,sum(t.mat_money) as total_mat_money from (");
			sql.append(getSpareAnalBasicSql());
			sql.append(" ) t where 1=1 ");
			// ���ʱ���
			if(StringUtils.isNotBlank(matCode)){
				sql.append(" and t.mat_code like '"+matCode+"%'");
			}
			// ��̽��
			if(StringUtils.isNotBlank(orgSubId)){
				sql.append(" and t.sub_id = '"+orgSubId+"' ");
			}
			// ��ʼʱ��
			sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
			// ����ʱ��
			sql.append(" and t.mat_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
			sql.append(" group by t.mat_code,t.mat_name order by t.mat_code ");
			List<Map<String,String>> datas=new ArrayList<Map<String,String>>();
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			for (int i = 0; i < list.size(); i++) {
				Map map = list.get(i);
				Map data = new HashMap();
				data.put("excel_column_val0", i + 1);
				data.put("excel_column_val1", map.get("mat_code"));
				data.put("excel_column_val2", map.get("mat_name"));
				data.put("excel_column_val3", map.get("total_mat_money"));
				datas.add(data);
			}
			String orgName = getOrgName(orgSubId);
			String excelName =  "����������ȡ��Ϣ"
					+ ".xls";
			String title =  "����������ȡ��Ϣ";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("���ʱ���");
			headerList.add("��������");
			headerList.add("���Ľ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		//ά��������ȡĳ�����͵���
		if("wxfyzqxxlx".equals(exportFlag)){
			
 
			//��ȡ��ǰ���
			Calendar cal = Calendar.getInstance();
			Integer year = cal.get(Calendar.YEAR);
			String currentYear=year.toString();
			//��ȡ��ǰʱ��
			Date now = new Date();
			SimpleDateFormat dateFormat = new SimpleDateFormat(
					"yyyy-MM-dd");
			String currentDate=dateFormat.format(now);
			String devTreeId = msg.getValue("devTreeId");//  tree����
			String orgSubId = msg.getValue("orgSubId");// ��̽��
			String country = msg.getValue("country");// ����/����
			String project_id=msg.getValue("project_id");
			String vcountry="";
			if(StringUtils.isNotBlank(country)){
				if("1".equals(country)){
					vcountry="����";
				}
				if("2".equals(country)){
					vcountry="����";			
				}
			}
			// ��ʼʱ��
			String startDate = msg.getValue("startDate");
			// ����ʱ��
			String endDate = msg.getValue("endDate");
			String _startDate="";
			String _endDate="";
			if(StringUtils.isNotBlank(startDate)){
				_startDate=startDate;
			}else{
				_startDate=(currentYear+"-01-01").trim();
			}
			if(StringUtils.isNotBlank(endDate)){
				_endDate=endDate;
			}else{
				_endDate=currentDate;
			}
			String sql1="select t.dev_name, t.dev_model, t.self_num, t.license_num, t.dev_sign, sum(repair_cost) as repair_cost from dms_device_tree dt inner join(select * from (select nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) as repair_cost, case when ri.repair_level = '605' then 'baoyang' else 'weixiu' end as repair_type, ri.repair_start_date as repair_date, 'xcwx' data_type, dui.dev_type, acc.ifcountry, dui.dev_name, dui.dev_model, dui.self_num, dui.license_num, dui.dev_sign, nvl(dui.asset_value, 0) as asset_value, nvl(dui.net_value, 0) as net_value, ri.project_info_no, case when dui.owning_sub_id like 'C105001%' then substr(dui.owning_sub_id, 1, 10) when dui.owning_sub_id like 'C105005%' then substr(dui.owning_sub_id, 1, 10) else substr(dui.owning_sub_id, 1, 7) end as sub_id from bgp_comm_device_repair_info ri left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0' left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag = '0' where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no ='"+project_id+"') tmp0 where 1 = 1 and tmp0.repair_date >= to_date('"+startDate+"', 'yyyy-mm-dd') and tmp0.repair_date <= to_date('"+endDate+"', 'yyyy-mm-dd')) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null " ;
			// tree����
					if(StringUtils.isNotBlank(devTreeId)){
						sql1+=" and dt.dev_tree_id like '" + devTreeId + "%'";
					}
					sql1+=	" group by t.dev_name, t.dev_model, t.self_num, t.license_num, t.dev_sign order by t.self_num, t.license_num";
			StringBuilder sql = new StringBuilder();
			sql.append("select t.dev_name,t.dev_model,t.self_num,t.license_num,t.dev_sign,sum(repair_cost) as repair_cost "
					+ " from dms_device_tree dt "
			        + " inner join ( select * from ( ");
			sql.append(getRepairAnalBasicSql());
			sql.append(" ) tmp0 where 1=1");
			// ��̽��
			if(StringUtils.isNotBlank(orgSubId)){
				sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
			}
			// ���ڹ���
			if(StringUtils.isNotBlank(vcountry)){
				sql.append(" and tmp0.ifcountry='"+vcountry+"'");
			}
			// ��ʼʱ��
			sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
			// ����ʱ��
			sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
			sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null ");
			// tree����
			if(StringUtils.isNotBlank(devTreeId)){
				sql.append(" and dt.dev_tree_id like '" + devTreeId + "%'");
			}
			sql.append(" group by t.dev_name,t.dev_model,t.self_num,t.license_num,t.dev_sign");
			sql.append(" order by t.self_num,t.license_num ");
			if(StringUtils.isNotBlank(project_id)&&!"null".equals(project_id)){
				sql=new StringBuilder(sql1);
			}
			List<Map<String,String>> datas=new ArrayList<Map<String,String>>();
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			for (int i = 0; i < list.size(); i++) {
				Map map = list.get(i);
				Map data = new HashMap();
				data.put("excel_column_val0", i + 1);
				data.put("excel_column_val1", map.get("dev_name"));
				data.put("excel_column_val2", map.get("dev_model"));
				data.put("excel_column_val3", map.get("self_num"));
				data.put("excel_column_val4",map.get("license_num") );
				data.put("excel_column_val5", map.get("dev_sign"));
				data.put("excel_column_val6", map.get("repair_cost"));
				datas.add(data);
			}
			String orgName = getOrgName(orgSubId);
			String excelName =  "ά�޷�����ȡ��Ϣ"
					+ ".xls";
			String title =  "ά�޷�����ȡ��Ϣ";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("���պ� ");
			headerList.add("ʵ���ʶ��");
			headerList.add("ά�޷���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", datas);
		}
		// �ֳ�ά�޷�����ȡ��Ϣ-�豸����
		if ("xcwxfyzqxxsblx".equals(exportFlag)) {
			String code = msg.getValue("code");
			String orgsubId = msg.getValue("orgsubId");
			String proYear = msg.getValue("proYear");
			String sql = "select pro.project_name as excel_column_val0,dui.dev_acc_id ,dui.dev_name as excel_column_val1,dui.dev_model as excel_column_val2,"
					+ "self_num as excel_column_val3,dev_sign as excel_column_val4,license_num as excel_column_val5,sum(det.total_charge)  as excel_column_val6 "
					+ "from bgp_comm_device_repair_info rep "
					+ "left join bgp_comm_device_repair_detail det on det.repair_info=rep.repair_info "
					+ "left join gms_device_account_dui dui on dui.dev_acc_id=rep.device_account_id "
					+ "left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ "left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' "
					+ "where dui.project_info_id is not null and dym.org_subjection_id like '"
					+ orgsubId
					+ "%'"
					+ "and det.total_charge>0 and dui.dev_acc_id is not null and rep.repair_item='"
					+ code
					+ "' "
					+ "and substr(to_char(rep.repair_end_date,'yyyy-mm-dd'),1,4)='"
					+ proYear
					+ "' "
					+ "group by pro.project_name,dui.dev_acc_id,dui.dev_name,dui.dev_model,self_num,dev_sign,license_num "
					+ "order by pro.project_name,dui.dev_acc_id,dui.dev_name,dui.dev_model ";
			List<Map> list = jdbcDao.queryRecords(sql);
			String titleType = getCodeName(code);
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "�ֳ�ά�޷�����ȡ��Ϣ-"
					+ titleType + ".xls";
			String title = proYear + "���" + orgName + "�ֳ�ά�޷�����ȡ��Ϣ-" + titleType;
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("��Ŀ����");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// �ֳ�ά�޷�����ȡ��Ϣ-�豸��Ϣ
		if ("xcwxfyzqxxsbxx".equals(exportFlag)) {
			String code = msg.getValue("code");
			String devaccid = msg.getValue("devaccid");
			String orgsubId = msg.getValue("orgsubId");
			String proYear = msg.getValue("proYear");
			String sql = "select rep.repair_info,pro.project_name as excel_column_val0 ,dui.dev_acc_id,dui.dev_name as excel_column_val1,dui.dev_model as excel_column_val2,"
					+ "self_num as excel_column_val3,dev_sign as excel_column_val4,license_num as excel_column_val5,to_char(rep.repair_start_date,'yyyy-mm-dd') as excel_column_val6,"
					+ "to_char(rep.repair_end_date,'yyyy-mm-dd') as  excel_column_val7,sum(det.total_charge) as  excel_column_val8 "
					+ "from bgp_comm_device_repair_info rep "
					+ "left join bgp_comm_device_repair_detail det on det.repair_info=rep.repair_info "
					+ "left join gms_device_account_dui dui on dui.dev_acc_id=rep.device_account_id "
					+ "left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ "left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' "
					+ "where dui.project_info_id is not null and dym.org_subjection_id like '"
					+ orgsubId
					+ "%'"
					+ "and det.total_charge>0 and dui.dev_acc_id='"
					+ devaccid
					+ "' and rep.repair_item='"
					+ code
					+ "' "
					+ "group by rep.repair_info,pro.project_name,dui.dev_acc_id,dui.dev_name,dui.dev_model,self_num,dev_sign,license_num,"
					+ "to_char(rep.repair_start_date, 'yyyy-mm-dd'),to_char(rep.repair_end_date, 'yyyy-mm-dd')"
					+ "order by rep.repair_info,pro.project_name,dui.dev_acc_id,dui.dev_name,dui.dev_model";
			List<Map> list = jdbcDao.queryRecords(sql);
			String titleType = getCodeName(code);
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "�豸ά�޷���-" + titleType
					+ ".xls";
			String title = proYear + "���" + orgName + "�豸ά�޷���-" + titleType;
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("��Ŀ����");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("ά�޿�ʼʱ��");
			headerList.add("ά�޽���ʱ��");
			headerList.add("���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// �ֳ�ά����ȡ��Ϣ<С��Ʒ>
		if ("xcwxfyzqxxxyp".equals(exportFlag)) {
			String code = msg.getValue("code");
			String orgsubId = msg.getValue("orgsubId");
			String proYear = msg.getValue("proYear");
			String sql = "select pro.project_name as excel_column_val0,dui.dev_acc_id,dui.dev_name as excel_column_val1,dui.dev_model as excel_column_val2,"
					+ "self_num as excel_column_val3,dev_sign as excel_column_val4,license_num as excel_column_val5,sum(oil.oil_total)  as excel_column_val6 "
					+ "from bgp_comm_device_oil_info oil "
					+ "left join gms_device_account_dui dui on dui.dev_acc_id=oil.device_account_id "
					+ "left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ "left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' "
					+ "where dui.project_info_id is not null and dym.org_subjection_id like '"
					+ orgsubId
					+ "%'"
					+ "and substr(to_char(oil.fill_date,'yyyy-mm-dd'),1,4)='"
					+ proYear
					+ "' "
					+ "and oil.oil_total>0 and dui.dev_acc_id is not null "
					+ "group by pro.project_name,dui.dev_acc_id,dui.dev_name,dui.dev_model,self_num,dev_sign,license_num "
					+ "order by pro.project_name,dui.dev_acc_id,dui.dev_name,dui.dev_model  ";
			List<Map> list = jdbcDao.queryRecords(sql);
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "�ֳ�ά�޷�����ȡ��Ϣ-С��Ʒ.xls";
			String title = proYear + "���" + orgName + "�ֳ�ά�޷�����ȡ��Ϣ-С��Ʒ";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("��Ŀ����");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// �ֳ�ά����ȡ��Ϣ<С��Ʒ��Ϣ>
		if ("xcwxfyzqxxxypxx".equals(exportFlag)) {
			String code = msg.getValue("code");
			String orgsubId = msg.getValue("orgsubId");
			String devaccid = msg.getValue("devaccid");
			String proYear = msg.getValue("proYear");
			String sql = "select pro.project_name as excel_column_val0,dui.dev_acc_id,dui.dev_name as excel_column_val1,dui.dev_model as excel_column_val2,"
					+ "self_num as excel_column_val3,dev_sign as excel_column_val4,license_num as excel_column_val5,to_char(fill_date,'yyyy-mm-dd') as excel_column_val6,oil.oil_total as excel_column_val7 "
					+ "from bgp_comm_device_oil_info oil "
					+ "left join gms_device_account_dui dui on dui.dev_acc_id=oil.device_account_id "
					+ "left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ "left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' "
					+ "where dui.project_info_id is not null and dym.org_subjection_id like '"
					+ orgsubId
					+ "%'"
					+ "and oil.oil_total>0 and dui.dev_acc_id ='"
					+ devaccid
					+ "' ";
			List<Map> list = jdbcDao.queryRecords(sql);
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "�豸ά�޷���-С��Ʒ.xls";
			String title = proYear + "���" + orgName + "�豸ά�޷���-С��Ʒ";
			List<String> headerList = new ArrayList<String>();
			headerList.add("���");
			headerList.add("��Ŀ����");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("�Ա��");
			headerList.add("ʵ���ʶ��");
			headerList.add("���պ�");
			headerList.add("��ע����");
			headerList.add("���");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����������̬���
		if ("dzyqdtqk".equals(exportFlag)) {
			String sql = "select ci.node_type_id,sd.coding_name as excel_column_val0,sum(ci.dev_slot_num*total_num) as excel_column_val1,"
					+ "sum(ci.dev_slot_num*use_num) as excel_column_val2,sum(ci.dev_slot_num*unuse_num) as excel_column_val3,"
					+ "sum(ci.dev_slot_num*repairing_num) as excel_column_val4 "
					+ "from gms_device_coll_account ca "
					+ "join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id "
					+ "join gms_device_collectinfo ci on ca.device_id=ci.device_id "
					+ "left join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id "
					+ "where ci.node_type_id is not null "
					+ "group by ci.node_type_id,sd.coding_name";
			List<Map> list = jdbcDao.queryRecords(sql);
			String excelName = "����������̬���.xls";
			String title = "����������̬���";
			List<String> headerList = new ArrayList<String>();
			headerList.add("����ͺ�");
			headerList.add("����");
			headerList.add("����");
			headerList.add("����");
			headerList.add("ά��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��Ҫ�豸�¶�ϵ��
		if ("zysbxdxs".equals(exportFlag)) {
			String orgstrId = null;
			String orgsubId = null;
			String drillLevel = msg.getValue("drillLevel");
			if (drillLevel != null && "1".equals(drillLevel)) {
				orgstrId = msg.getValue("orgstrId");
				orgsubId = msg.getValue("orgsubId");
				if ((orgsubId == null || "".equals(orgsubId))) {
					String subidsql = "select org_subjection_id as orgsubid from comm_org_subjection where org_id='"
							+ orgstrId + "' and bsflag='0' ";
					Map tmpMap = jdbcDao.queryRecordBySQL(subidsql);
					orgsubId = tmpMap.get("orgsubid").toString();
				}
			}
			String xindusql = "select trunc(allnetvalue/10000,2) as excel_column_val2,"
					+ "trunc(allassetvalue/10000,2) as excel_column_val1,trunc(allnetvalue/allassetvalue,2) as excel_column_val3 "
					+ "from (select sum(net_value) as allnetvalue,sum(asset_value) as allassetvalue "
					+ "from gms_device_account where account_stat='0110000013000000003' ";
			if (drillLevel != null && "1".equals(drillLevel)) {
				// ��������Ϊ�գ�˵������̽����
				xindusql += "and owning_sub_id like '" + orgsubId + "%'";
			}
			xindusql += "and (dev_type like 'S0601%' or dev_type like 'S062301%' or dev_type like 'S08%' "
					+ "or dev_type like 'S070301%' or dev_type like 'S14050208%' )) tmp";
			// ͳ��5����ֵ
			Map dataMap = jdbcDao.queryRecordBySQL(xindusql);
			if (null == orgsubId) {
				orgsubId = "C105";
			}
			String orgnamesql = "select org_abbreviation as excel_column_val0 from comm_org_information org "
					+ "left join comm_org_subjection suborg on org.org_id=suborg.org_id and suborg.bsflag='0' "
					+ "where suborg.org_subjection_id='" + orgsubId + "'";
			Map tmpMap = jdbcDao.queryRecordBySQL(orgnamesql);
			List<Map> list = new ArrayList<Map>();
			dataMap.putAll(tmpMap);
			list.add(dataMap);
			String excelName = "��Ҫ�豸�¶�ϵ��.xls";
			String title = "��Ҫ�豸�¶�ϵ��<"
					+ tmpMap.get("excel_column_val0").toString() + ">";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��λ����");
			headerList.add("�ʲ�ԭֵ����Ԫ��");
			headerList.add("�ʲ���ֵ����Ԫ��");
			headerList.add("�¶�ϵ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��˾����Ҫ�豸�¶�ϵ����ȡ���
		if ("gsjzysbxdxszqqk".equals(exportFlag)) {
			String[] orgNames = new String[] { "C105001002%-�½���̽��",
					"C105001003%-�¹���̽��", "C105001004%-�ຣ��̽��",
					"C105005004%-������̽��", "C105005000%-������̽��", "C105063%-�ɺ���̽��",
					"C105001005%-����ľ��̽��", "C105005001%-������̽������",
					"C105007%-�����̽��", "C105006%-װ������" };
			String xindusql = "select trunc(allnetvalue/10000,2) as excel_column_val2, trunc(allassetvalue/10000,2) as excel_column_val1,trunc(allnetvalue/allassetvalue,2) as excel_column_val3 "
					+ "from (select sum(net_value) as allnetvalue,sum(asset_value) as allassetvalue "
					+ "from gms_device_account where account_stat='0110000013000000003' "
					+ "and (dev_type like 'S0601%' or dev_type like 'S062301%' or dev_type like 'S08%' "
					+ "or dev_type like 'S070301%' or dev_type like 'S14050208%' ) "
					+ "and owning_sub_id like '@%') tmp";
			List<Map> list = new ArrayList<Map>();
			for (int j = 0; j < orgNames.length; j++) {
				Map dataMap = jdbcDao.queryRecordBySQL(xindusql.replaceAll("@",
						orgNames[j].split("-")[0]));
				dataMap.put("excel_column_val0", orgNames[j].split("-")[1]);
				list.add(dataMap);
			}
			String excelName = "��Ҫ�豸�¶�ϵ����ȡ���.xls";
			String title = "��Ҫ�豸�¶�ϵ����ȡ���";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��λ����");
			headerList.add("�ʲ�ԭֵ����Ԫ��");
			headerList.add("�ʲ���ֵ����Ԫ��");
			headerList.add("�¶�ϵ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��̽����Ҫ�豸�¶�ϵ����ȡ���
		if ("wtczysbxuxszqqk".equals(exportFlag)) {
			String code = msg.getValue("code");
			String orgsubId = msg.getValue("orgsubId");
			if (orgsubId == null || "".equals(orgsubId)
					|| "null".equals(orgsubId)) {
				String subidsql = "select org_subjection_id as orgsubid from comm_org_subjection where org_id='"
						+ code + "' and bsflag='0' ";
				Map tmpMap = jdbcDao.queryRecordBySQL(subidsql);
				orgsubId = tmpMap.get("orgsubid").toString();
			}
			String[] typeNames = null;
			if ("C105006".equals(orgsubId)) {
				typeNames = new String[] { "S062301-�ɿ���Դ", "S1404-��������",
						"S08-�����豸", "S140501-��������" };
			} else if ("C105007".equals(orgsubId)
					|| "C1050635".equals(orgsubId)) {
				typeNames = new String[] { "S0601-���", "S08-�����豸",
						"S070301-������", "S14050208-�첨��", "S062301-�ɿ���Դ",
						"S1404-��������" };
			} else {
				typeNames = new String[] { "S0601-���", "S08-�����豸",
						"S070301-������", "S14050208-�첨��" };
			}
			String xindusql = "select trunc(allnetvalue/10000,2) as excel_column_val2,trunc(allassetvalue/10000,2) as excel_column_val1,trunc(allnetvalue/allassetvalue,2) as excel_column_val3 "
					+ "from (select sum(net_value) as allnetvalue,sum(asset_value) as allassetvalue "
					+ "from gms_device_account where account_stat='0110000013000000003' and owning_sub_id like '"
					+ orgsubId + "%' " + "and dev_type like '@%') tmp";
			List<Map> list = new ArrayList<Map>();
			for (int j = 0; j < typeNames.length; j++) {
				Map dataMap = jdbcDao.queryRecordBySQL(xindusql.replaceAll("@",
						typeNames[j].split("-")[0]));
				dataMap.put("excel_column_val0", typeNames[j].split("-")[1]);
				list.add(dataMap);
			}
			String orgName = getOrgName(orgsubId);
			String excelName = orgName + "��Ҫ�豸�¶�ϵ����ȡ���.xls";
			String title = orgName + "��Ҫ�豸�¶�ϵ����ȡ���";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("�ʲ�ԭֵ����Ԫ��");
			headerList.add("�ʲ���ֵ����Ԫ��");
			headerList.add("�¶�ϵ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��������(�����豸)��ȡ���
		if ("dzyqxzsbzqqk".equals(exportFlag)) {
			String code = msg.getValue("code");
			String[] orgNames = new String[] { "%-����", "C105006002-������������",
					"C105006008-����ľ��ҵ��", "C105006005-������ҵ��",
					"C105006009-�¹���ҵ��", "C105006006-�ػ���ҵ��", "C105006004-������ҵ��",
					"C105006007-������ҵ��", "C105006011-������ҵ��", "C105063-�ɺ���̽��",
					"C105007-�����̽��" };
			String wutansb = "select sd.coding_name as label,sum(ci.dev_slot_num*unuse_num) as excel_column_val1 "
					+ " from gms_device_coll_account ca "
					+ "  left join comm_org_subjection s on ca.usage_org_id = s.org_id  and s.bsflag = '0' "
					+ " join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id "
					+ "  join gms_device_collectinfo ci on ca.device_id=ci.device_id  "
					+ "  join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id  "
					+ " where ci.node_type_id is not null "
					+ " and ci.node_type_id='"
					+ code
					+ "' "
					+ " and s.org_subjection_id like '@' "
					+ "  group by sd.coding_name";
			List<Map> list = new ArrayList<Map>();
			for (int j = 0; j < orgNames.length; j++) {
				Map dataMap = jdbcDao.queryRecordBySQL(wutansb.replaceAll("@",
						orgNames[j].split("-")[0]));
				if (MapUtils.isEmpty(dataMap)) {
					dataMap = new HashMap();
					dataMap.put("excel_column_val1", 0);
				}
				dataMap.put("excel_column_val0", orgNames[j].split("-")[1]);
				list.add(dataMap);
			}
			String excelName = "��������(�����豸)��ȡ���.xls";
			String title = "��������(�����豸)��ȡ���";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��λ����");
			headerList.add("����������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��������(�����豸)��ȡ���
		if ("dzyqzysbzqqk".equals(exportFlag)) {
			String code = msg.getValue("code");
			String searchWutanchuSql = "select distinct orgsubparent.org_subjection_id||'-'||org.org_abbreviation as org_name "
					+ "from gms_device_coll_account_dui dui "
					+ "join gms_device_collectinfo ci on dui.device_id=ci.device_id "
					+ "join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no "
					+ "join comm_org_subjection orgsub on dym.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' "
					+ "join comm_org_subjection orgsubparent on orgsub.father_org_id=orgsubparent.org_subjection_id and orgsubparent.bsflag='0' "
					+ "join comm_org_information org on orgsubparent.org_id=org.org_id "
					+ "where dui.project_info_id is not null and dui.is_leaving='0' and ci.node_type_id='"
					+ code + "' ";
			List<Map> orgNamesList = jdbcDao.queryRecords(searchWutanchuSql);
			Map zlMap = new HashMap();
			zlMap.put("org_name", "%-����");
			orgNamesList.add(0, zlMap);
			String wutansb = "select sd.coding_name as label,sum(ci.dev_slot_num*dui.unuse_num) as excel_column_val1 "
					+ " from gms_device_coll_account_dui dui "
					+ " join gms_device_collectinfo ci on dui.device_id=ci.device_id "
					+ " join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id  "
					+ " join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no "
					+ " join comm_org_subjection orgsub on dym.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' "
					+ " join comm_org_subjection orgsubparent on orgsub.father_org_id=orgsubparent.org_subjection_id and orgsubparent.bsflag='0' "
					+ " join comm_org_information org on orgsubparent.org_id=org.org_id "
					+ " where dui.project_info_id is not null and dui.is_leaving='0' "
					+ " and orgsubparent.org_subjection_id like '@' "
					+ " and ci.node_type_id is not null "
					+ " and ci.node_type_id='"
					+ code
					+ "'"
					+ " group by sd.coding_name";
			List<Map> list = new ArrayList<Map>();
			for (int j = 0; j < orgNamesList.size(); j++) {
				Map dataMap = jdbcDao.queryRecordBySQL(wutansb.replaceAll(
						"@",
						orgNamesList.get(j).get("org_name").toString()
								.split("-")[0]));
				if (MapUtils.isEmpty(dataMap)) {
					dataMap = new HashMap();
					dataMap.put("excel_column_val1", 0);
				}
				dataMap.put(
						"excel_column_val0",
						orgNamesList.get(j).get("org_name").toString()
								.split("-")[1]);
				list.add(dataMap);
			}
			String excelName = "��������(�����豸)��ȡ���.xls";
			String title = "��������(�����豸)��ȡ���";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��λ����");
			headerList.add("����������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ��̽����������(�����豸)
		if ("xmxxdzyqzysb".equals(exportFlag)) {
			String code = msg.getValue("code");
			String suborgid = msg.getValue("orgsubid");
			String wutansb = "select pro.project_name as excel_column_val0,dui.project_info_id,sd.coding_name as label,sum(ci.dev_slot_num*dui.unuse_num) as excel_column_val1 "
					+ " from gms_device_coll_account_dui dui "
					+ " join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ " join gms_device_collectinfo ci on dui.device_id=ci.device_id "
					+ " join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id "
					+ " join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no "
					+ " join comm_org_subjection orgsub on dym.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' "
					+ " join comm_org_subjection orgsubparent on orgsub.father_org_id=orgsubparent.org_subjection_id and orgsubparent.bsflag='0' "
					+ " join comm_org_information org on orgsubparent.org_id=org.org_id "
					+ " where dui.project_info_id is not null and dui.is_leaving='0' "
					+ " and orgsubparent.org_subjection_id='"
					+ suborgid
					+ "' "
					+ " and ci.node_type_id is not null and nvl(dui.unuse_num,0) <>0 and nvl(ci.dev_slot_num,0) <>0 "
					+ " and ci.node_type_id='"
					+ code
					+ "' "
					+ " group by pro.project_name,dui.project_info_id,sd.coding_name ";
			List<Map> list = jdbcDao.queryRecords(wutansb);
			String orgName = getOrgName(suborgid);
			String excelName = orgName + "��������(�����豸)��Ϣ.xls";
			String title = orgName + "��������(�����豸)��Ϣ";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��Ŀ����");
			headerList.add("����������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����Ŀ��Ҫ�豸Ͷ��ͳ��
		if ("gxmzysbtrtj".equals(exportFlag)) {
			String orgstrId = msg.getValue("orgstrId");
			String orgsubId = msg.getValue("orgsubId");
			String proYear = msg.getValue("proYear");
			if (orgsubId == null || "".equals(orgsubId)) {
				String subidsql = "select org_subjection_id as orgsubid from comm_org_subjection where org_id='"
						+ orgstrId + "' and bsflag='0' ";
				Map tmpMap = jdbcDao.queryRecordBySQL(subidsql);
				orgsubId = tmpMap.get("orgsubid").toString();
			}
			String sql = "select '������' as excel_column_val0, count(*) as excel_column_val1 from gms_device_account_dui dui left join gp_task_project_dynamic dym "
					+ " on dui.project_info_id = dym.project_info_no and dym.bsflag = '0' left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ " where dui.project_info_id is not null and dev_type like 'S070301%' and pro.project_year='"
					+ proYear
					+ "'"
					+ " and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " union all "
					+ " select '��װ���' as excel_column_val0, count(*) as excel_column_val1 from gms_device_account_dui dui left join gp_task_project_dynamic dym "
					+ " on dui.project_info_id = dym.project_info_no and dym.bsflag = '0' left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ " where dui.project_info_id is not null and dev_type like 'S060101%' and pro.project_year='"
					+ proYear
					+ "'"
					+ " and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " union all "
					+ " select '��̧�����' as excel_column_val0, count(*) as excel_column_val1 from gms_device_account_dui dui left join gp_task_project_dynamic dym "
					+ " on dui.project_info_id = dym.project_info_no and dym.bsflag = '0' left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ " where dui.project_info_id is not null and dev_type like 'S060102%' and pro.project_year='"
					+ proYear
					+ "'"
					+ " and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " union all "
					+ " select '�����豸' as excel_column_val0, count(*) as excel_column_val1 from gms_device_account_dui dui left join gp_task_project_dynamic dym "
					+ " on dui.project_info_id = dym.project_info_no and dym.bsflag = '0' left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ " where dui.project_info_id is not null and dev_type like 'S08%' and pro.project_year='"
					+ proYear
					+ "'"
					+ " and dym.org_subjection_id like '"
					+ orgsubId + "%' ";
			List<Map> list = jdbcDao.queryRecords(sql);
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "����Ŀ��Ҫ�豸Ͷ��ͳ��.xls";
			String title = proYear + "���" + orgName + "����Ŀ��Ҫ�豸Ͷ��ͳ��";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����Ŀ�ɼ��豸�ֲ�
		if ("gxmcjsbfb".equals(exportFlag)) {
			String orgstrId = msg.getValue("orgstrId");
			String orgsubId = msg.getValue("orgsubId");
			String proYear = msg.getValue("proYear");
			if (orgsubId == null || "".equals(orgsubId)) {
				String subidsql = "select org_subjection_id as orgsubid from comm_org_subjection where org_id='"
						+ orgstrId + "' and bsflag='0' ";
				Map tmpMap = jdbcDao.queryRecordBySQL(subidsql);
				orgsubId = tmpMap.get("orgsubid").toString();
			}
			String sql = "select '��������(��)' as excel_column_val0,nvl(sum(nvl(accdui.total_num, 0) * nvl(ci.dev_slot_num, 0) ),0) as excel_column_val1 "
					+ " from gms_device_coll_account_dui accdui left join gms_device_collectinfo ci on accdui.device_id = ci.device_id "
					+ " left join gp_task_project_dynamic dym on accdui.project_info_id = dym.project_info_no and dym.bsflag = '0' "
					+ " left join gp_task_project pro on accdui.project_info_id=pro.project_info_no "
					+ " where accdui.project_info_id is not null and pro.bsflag='0' and pro.project_year='"
					+ proYear
					+ "' "
					+ " and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " union all "
					+ " select '�ɿ���Դ(̨)' as excel_column_val0,count(*) as excel_column_val1 "
					+ " from gms_device_account_dui dui left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' "
					+ " left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ " where dui.project_info_id is not null and dev_type like 'S062301%' and pro.bsflag='0' and pro.project_year='"
					+ proYear
					+ "' "
					+ " and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " union all "
					+ " select '�첨��(��)' as excel_column_val0,count(*) as excel_column_val1 "
					+ " from gms_device_account_dui dui left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' "
					+ " left join gp_task_project pro on dui.project_info_id=pro.project_info_no "
					+ " where dui.project_info_id is not null and dev_type like 'S14050208%' and pro.bsflag='0' and pro.project_year='"
					+ proYear
					+ "' "
					+ " and dym.org_subjection_id like '"
					+ orgsubId + "%' ";
			List<Map> list = jdbcDao.queryRecords(sql);
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "����Ŀ�ɼ��豸�ֲ�.xls";
			String title = proYear + "���" + orgName + "����Ŀ�ɼ��豸�ֲ�";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("����");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����Ŀ��Ҫ�豸����ʡ�������
		if ("gxmzysbwhllyl".equals(exportFlag)) {
			String orgstrId = msg.getValue("orgstrId");
			String orgsubId = msg.getValue("orgsubId");
			String proYear = msg.getValue("proYear");
			if (orgsubId == null || "".equals(orgsubId)) {
				String subidsql = "select org_subjection_id as orgsubid from comm_org_subjection where org_id='"
						+ orgstrId + "' and bsflag='0' ";
				Map tmpMap = jdbcDao.queryRecordBySQL(subidsql);
				orgsubId = tmpMap.get("orgsubid").toString();
			}
			StringBuffer sb = new StringBuffer(
					"select case when zhidu.zhidutaitian = 0 or zhidu.zhidutaitian is null then 0 ")
					.append("else trunc(100*(zhidu.zhidutaitian-wanhao.nowanhao)/zhidu.zhidutaitian,2) end as excel_column_val0,")
					.append("case when zhidu.zhidutaitian = 0 or zhidu.zhidutaitian is null then 0 ")
					.append(" else trunc(100*(zhidu.zhidutaitian-liyong.noliyong)/zhidu.zhidutaitian,2) end as excel_column_val1 ")
					.append("from ( select '@' as proflag,sum(case when dui.actual_out_time is null ")
					.append("then to_number(trunc(sysdate,'dd')-trunc(actual_in_time,'dd')) ")
					.append("else to_number(trunc(actual_out_time,'dd')-trunc(actual_in_time,'dd')) end) as zhidutaitian ")
					.append("from gms_device_account_dui dui ")
					.append("left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' ")
					.append("left join gp_task_project pro  on dui.project_info_id = pro.project_info_no  ")
					.append("where dui.project_info_id is not null and dym.org_subjection_id like '"
							+ orgsubId + "%' ")
					.append("and pro.project_year='" + proYear + "' ")
					.append("and  (dev_type like 'S070301%' or dev_type like 'S060101%' or dev_type like 'S060102%' or dev_type like 'S08%') ")
					.append(") zhidu ")
					.append("left join ")
					.append("(select '@' as proflag,count(1) as nowanhao  ")
					.append("from bgp_comm_device_timesheet sheet ")
					.append("where exists(select 1 from gms_device_account_dui dui ")
					.append("left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' ")
					.append("left join gp_task_project pro  on dui.project_info_id = pro.project_info_no  ")
					.append("where dui.project_info_id is not null and dym.org_subjection_id like '"
							+ orgsubId + "%' ")
					.append("and pro.project_year='" + proYear + "' ")
					.append("and dui.dev_acc_id=sheet.device_account_id and timesheet_symbol in ('5110000041000000002') ")
					.append("and (dev_type like 'S070301%' or dev_type like 'S060101%' or dev_type like 'S060102%' or dev_type like 'S08%') ")
					.append(")) wanhao on zhidu.proflag = wanhao.proflag ")
					.append("left join ")
					.append("(select '@' as proflag,count(1) as noliyong  ")
					.append("from bgp_comm_device_timesheet sheet ")
					.append("where exists(select 1 from gms_device_account_dui dui ")
					.append("left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' ")
					.append("left join gp_task_project pro  on dui.project_info_id = pro.project_info_no  ")
					.append("where dui.project_info_id is not null and dym.org_subjection_id like '"
							+ orgsubId + "%' ")
					.append("and pro.project_year='" + proYear + "' ")
					.append("and dui.dev_acc_id=sheet.device_account_id ")
					.append("and timesheet_symbol in ('5110000041000000002','5110000041000000003') ")
					.append("and (dev_type like 'S070301%' or dev_type like 'S060101%' or dev_type like 'S060102%' or dev_type like 'S08%') ")
					.append(")) liyong on zhidu.proflag = liyong.proflag ");
			List<Map> list = jdbcDao.queryRecords(sb.toString());
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "����Ŀ��Ҫ�豸����ʡ�������.xls";
			String title = proYear + "���" + orgName + "����Ŀ��Ҫ�豸����ʡ�������";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸�����(%)");
			headerList.add("�豸������(%)");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����Ŀ���÷���
		if ("gxmfyfx".equals(exportFlag)) {
			String orgstrId = msg.getValue("orgstrId");
			String orgsubId = msg.getValue("orgsubId");
			String proYear = msg.getValue("proYear");
			if (orgsubId == null || "".equals(orgsubId)) {
				String subidsql = "select org_subjection_id as orgsubid from comm_org_subjection where org_id='"
						+ orgstrId + "' and bsflag='0' ";
				Map tmpMap = jdbcDao.queryRecordBySQL(subidsql);
				orgsubId = tmpMap.get("orgsubid").toString();
			}
			String sql = "select 'ά�����' as excel_column_val0,nvl(round(sum(nvl(total_charge,0))/10000,2),0) as excel_column_val1,nvl(sum(nvl(total_charge,0)),0) as t_fy "
					+ " from bgp_comm_device_repair_detail rd  join bgp_comm_device_repair_info ri on rd.repair_info=ri.repair_info join gms_device_account_dui dui on ri.device_account_id=dui.dev_acc_id "
					+ " left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' left join gp_task_project pro on dui.project_info_id=pro.project_info_no  and pro.bsflag='0' "
					+ " where dui.project_info_id is not null and ri.repair_level<>'605' "
					+ " and pro.project_year='"
					+ proYear
					+ "' "
					+ " and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " union all "
					+ " select '�������' as excel_column_val0,nvl(round(sum(nvl(total_charge,0))/10000,2),0) as excel_column_val1,nvl(sum(nvl(total_charge,0)),0) as t_fy "
					+ " from bgp_comm_device_repair_detail rd join bgp_comm_device_repair_info ri on rd.repair_info=ri.repair_info join gms_device_account_dui dui on ri.device_account_id=dui.dev_acc_id "
					+ " left join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no and dym.bsflag='0' left join gp_task_project pro on dui.project_info_id=pro.project_info_no and pro.bsflag='0'     "
					+ " where dui.project_info_id is not null and ri.repair_level='605' "
					+ " and pro.project_year='"
					+ proYear
					+ "' "
					+ " and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " union all "
					+ " select 'ȼ��' as excel_column_val0,nvl(round(sum(nvl(oil_total,0))/10000,2),0) as excel_column_val1,nvl(sum(nvl(oil_total,0)),0) as t_fy "
					+ " from ( select 'C105001002' as orgsubid, b.project_info_id, a.oil_total from bgp_comm_device_oil_info a "
					+ " left join gms_device_account_dui b on a.device_account_id = b.dev_acc_id "
					+ " left join gp_task_project c on b.project_info_id = c.project_info_no and c.bsflag='0'  "
					+ " left join gp_task_project_dynamic dym on b.project_info_id = dym.project_info_no and dym.bsflag = '0' "
					+ " where a.bsflag = '0' and a.oil_name in ('0110000043000000001', '0110000043000000002') "
					+ " and b.project_info_id in (select p.project_info_no from gp_task_project p join gp_task_project_dynamic dy on dy.bsflag = '0' "
					+ " and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method join comm_org_team t on dy.org_id = t.org_id "
					+ " left join bgp_pm_sap_org sap on sap.prctr = p.prctr left join comm_org_information org on sap.org_id = org.org_id and org.bsflag = '0' "
					+ "  where 1 = 1 and p.bsflag = '0'  and p.project_year='"
					+ proYear
					+ "' "
					+ "  and dy.org_subjection_id like '"
					+ orgsubId
					+ "%' ) and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " union "
					+ " select 'C105001002' as orgsubid,t.project_info_no,d.total_money from gms_mat_teammat_out t "
					+ " inner join gms_mat_teammat_out_detail d "
					+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id on t.teammat_out_id = d.teammat_out_id "
					+ " left join gp_task_project pro on t.project_info_no = pro.project_info_no and pro.bsflag='0' "
					+ " left join gp_task_project_dynamic dym on t.project_info_no=dym.project_info_no and dym.bsflag='0' "
					+ " where t.bsflag = '0' "
					+ " and t.project_info_no in (select p.project_info_no from gp_task_project p join gp_task_project_dynamic dy on dy.bsflag = '0' "
					+ " and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method join comm_org_team t on dy.org_id = t.org_id "
					+ " left join bgp_pm_sap_org sap on sap.prctr = p.prctr left join comm_org_information org on sap.org_id = org.org_id and org.bsflag = '0' "
					+ "  where 1 = 1 and p.bsflag = '0'  and p.project_year='"
					+ proYear
					+ "' "
					+ "  and dy.org_subjection_id like '"
					+ orgsubId
					+ "%' ) and dym.org_subjection_id like '"
					+ orgsubId
					+ "%' "
					+ " ) tmp1 group by orgsubid "
					+ " union all "
					+ " select 'С��Ʒ' as excel_column_val0, nvl(round(sum(nvl(oil_total,0))/10000,2),0) as excel_column_val1,nvl(sum(nvl(oil_total,0)),0) as t_fy "
					+ " from bgp_comm_device_oil_info oi join gms_device_account_dui dui on oi.device_account_id = dui.dev_acc_id "
					+ " left join gp_task_project_dynamic dym on dui.project_info_id = dym.project_info_no and dym.bsflag = '0' "
					+ " left join gp_task_project pro on dui.project_info_id=pro.project_info_no and pro.bsflag='0' "
					+ " where dui.project_info_id is not null and oil_name in('0110000043000000003','0110000043000000004','0110000043000000005','0110000043000000006') "
					+ " and pro.project_year='"
					+ proYear
					+ "'"
					+ " and dym.org_subjection_id like '" + orgsubId + "%' ";
			List<Map> list = jdbcDao.queryRecords(sql);
			if (CollectionUtils.isNotEmpty(list)) {
				float total_fy = 0;
				for (Map map : list) {
					total_fy += Float.parseFloat(map.get("t_fy").toString());
				}
				float total_wfy = new Float(total_fy) / 10000;
				Map fyMap = new HashMap();
				fyMap.put("excel_column_val0", "�ϼ�");
				fyMap.put("excel_column_val1", MessageFormat.format(
						"{0,number,0.00}", new Object[] { total_wfy }));
				list.add(fyMap);
			}
			String orgName = getOrgName(orgsubId);
			String excelName = proYear + "���" + orgName + "����Ŀ���÷���.xls";
			String title = proYear + "���" + orgName + "����Ŀ���÷���";
			List<String> headerList = new ArrayList<String>();
			headerList.add("��������");
			headerList.add("���ý���Ԫ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// zjb���������ѯ
		if ("bfsqcx".equals(exportFlag)) {
			// �������뵥��
			String scrape_apply_id = msg.getValue("scrape_apply_id");
			String scrape_type = msg.getValue("scrape_type");// �����豸���0123�������ϡ�������̭���̿�������
			Map headMap = new HashMap();
			List<Map> list = new ArrayList<Map>();
			if (!"null".equals(scrape_apply_id)) {
				StringBuilder sql = new StringBuilder(
						"select detailed.dev_name as excel_column_val0,"
								+ "detailed.dev_type as excel_column_val1,"
								+ "detailed.dev_coding as excel_column_val2,"
								+ "detailed.asset_coding as excel_column_val3,"
								+ "detailed.asset_value as excel_column_val4,"
								+ "detailed.net_value as excel_column_val5,"
								+ "detailed.producting_date as excel_column_val6,"
								+ "(case when detailed.scrape_type='0' then '��������' when detailed.scrape_type='1' then '������̭' when detailed.scrape_type='2' then '����' when detailed.scrape_type='3' then '�̿�' else  '' end)  as excel_column_val7,"
								+ "(case when detailed.sp_pass_flag='0' then 'ͨ��' when detailed.sp_pass_flag='1' then '��ͨ��' else  'δ֪' end) as excel_column_val8,"
								+ "detailed.sp_bak1 as excel_column_val9,(select org_name from comm_org_information i where org_id=detailed.org_id) as excel_column_val10 from dms_scrape_detailed detailed where detailed.scrape_apply_id in("
								+ scrape_apply_id + ")");
				if (StringUtils.isNotBlank(scrape_type)) {
					sql.append(" and detailed.scrape_type in('2','3')");
				}
				list = jdbcDao.queryRecords(sql.toString());
				
				StringBuilder headsql = new StringBuilder("SELECT T .*,( CASE WHEN t2.proc_status = '1' THEN '������' WHEN t2.proc_status = '3' THEN '����ͨ��' WHEN t2.proc_status = '4' THEN '������ͨ��' ELSE 'δ�ύ' END) AS apply_status, emp.employee_name, org.org_name AS org_name FROM dms_scrape_apply T LEFT JOIN common_busi_wf_middle t2 ON T .scrape_apply_id = t2.business_id AND t2.bsflag = '0' LEFT JOIN comm_human_employee emp ON T .employee_id = emp.employee_id LEFT JOIN comm_org_information org ON T .scrape_org_id = org.org_id WHERE T .bsflag = '0' AND T .scrape_apply_id IN( SELECT DISTINCT T .scrape_apply_id FROM dms_scrape_detailed T WHERE T .bsflag = '0') AND T.SCRAPE_APPLY_ID ="
						 		+ scrape_apply_id);
				headMap = jdbcDao.queryRecordBySQL(headsql.toString());
				}
				
			String excelName = "�����豸�������.xls";
			String title = "�����豸�������";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("�豸����");
			headerList.add("�豸���");
			headerList.add("�ʲ�����");
			headerList.add("ԭֵ");
			headerList.add("��ֵ");
			headerList.add("Ͷ������");
			headerList.add("����ԭ��");
			headerList.add("��ע");
			headerList.add("����״̬");
			headerList.add("��ҵ��");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
			responseMsg.setValue("headMap", headMap);
		}
		// zjb������Ϣ��ѯ�����豸��� 2017��11��20��11:02:47
		if ("bfxxcx".equals(exportFlag)) {
			// �������뵥��
			String dev_type = msg.getValue("dev_type");
			String collect_date = msg.getValue("collect_date");//���
			String scrape_type = msg.getValue("scrape_type");// �����豸���0123�������ϡ�������̭���̿�������
			List<Map> list = new ArrayList<Map>();
			if (!"null".equals(dev_type)) {
				String myDevTypeSql = "";
				if(dev_type.equals("other")){
					myDevTypeSql = " and detailed.dev_type not like 'S08%'"
							  + " and detailed.dev_type not like 'S0601%'"
							  + " and detailed.dev_type not like 'S070301%'"
							  + " and detailed.dev_type not like 'S14050301%'"
							  + " and detailed.dev_type not like 'S140501%' "
							  + " and detailed.dev_type not like 'S0623%'";
				}else{
					myDevTypeSql = " and detailed.dev_type like '"+dev_type+"%'";
				}
				StringBuilder sql = new StringBuilder("select detailed.dev_type as excel_column_val0,"
						+ "detailed.dev_coding as excel_column_val1,"
						+ "detailed.asset_coding as excel_column_val2,"
						+ "detailed.dev_name as excel_column_val3,"
						+ "detailed.dev_model as excel_column_val4,"
						+ "detailed.license_num as excel_column_val5,"
						+ "detailed.producting_date as excel_column_val6,"
						+ "case when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '���꼰����' "
						+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '���굽����' "
						+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '���굽����' "
						+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then 'һ�굽����' "
						+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then 'һ������' "
						+ "else 'δ֪ʱ��' end as excel_column_val7,"
						+ "n.org_name as excel_column_val8,"
						+ "detailed.asset_value as excel_column_val9,"
						+ "'/' as excel_column_val10,"
						+ "'/' as excel_column_val11,"
						+ "detailed.net_value as excel_column_val12,"
						+ "(case when detailed.scrape_type='0' then '��������' when detailed.scrape_type='1' then '������̭' when detailed.scrape_type='2' then '����' when detailed.scrape_type='3' then '�̿�' else  '' end)  as excel_column_val13,"
						+ "(case when detailed.sp_pass_flag='0' then 'ͨ��' when detailed.sp_pass_flag='1' then '��ͨ��' else  'δ֪' end) as excel_column_val4,"
						+ "detailed.sp_bak1 as excel_column_val15,"
						+ "detailed.duty_unit as excel_column_val16,"
						+ "detailed.team_name as excel_column_val17 "
						+ "from dms_scrape_detailed detailed "
						+ "left join comm_org_information n on n.org_id = detailed.org_id "
						+ "left join dms_scrape_apply app on app.scrape_apply_id = detailed.scrape_apply_id where 1=1 and detailed.bsflag='0' "+myDevTypeSql);
				//if(!user.getOrgCode().equals("C105")){
					//sql.append(" and app.scrape_org_id ='"+user.getOrgId()+"'");
				//}
				if (StringUtils.isNotBlank(scrape_type)) {
					sql.append(" and detailed.scrape_type in('2','3')");
				}
				if(collect_date!=null && collect_date!=""){
					sql.append(" and to_char(detailed.scrape_date,'yyyy') = "+collect_date);
				}
				list = jdbcDao.queryRecords(sql.toString());
			}
			String excelName = "�����豸�������.xls";
			String title = "�����豸�������";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("�豸���");
			headerList.add("�ʲ�����");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("���պ�");
			headerList.add("����ʱ��");
			headerList.add("�۾�����");
			headerList.add("��ҵ��");
			headerList.add("ԭֵ");
			headerList.add("�ۼ��۾�");
			headerList.add("��ֵ׼��");
			headerList.add("����");
			headerList.add("����ԭ��");
			headerList.add("����״̬");
			headerList.add("��ע");
			headerList.add("���ε�λ");
			headerList.add("��������");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// zjb���������ѯ
		if ("bfpscx".equals(exportFlag)) {
			// �������뵥��
			String scrape_collect_id = msg.getValue("scrape_collect_id");
			String sp_pass_flag = msg.getValue("sp_pass_flag");
			List<Map> list = new ArrayList<Map>();
			if (!"null".equals(scrape_collect_id)) {
				StringBuilder sql = new StringBuilder(
						" select  "
						+ "detailed.dev_type as excel_column_val0,"
						+ "detailed.dev_coding as excel_column_val1,"
						+ "temp.asset_coding as excel_column_val2,"
						+ "detailed.dev_name as excel_column_val3,"
						+ "detailed.dev_model as excel_column_val4,"
						+ "detailed.license_num as excel_column_val5,"
						+ "detailed.producting_date as excel_column_val6,"
						+ "case  when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '���꼰����' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '���굽����' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '���굽����' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then 'һ�굽����' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then 'һ������' else 'δ֪ʱ��' end as excel_column_val7,"
						+ "n.org_name as excel_column_val8,"
						+ "'/' as excel_column_val9,"
						+ "'/' as excel_column_val10,"
						+ "'1' as excel_column_val11,"
						+ "detailed.asset_value as excel_column_val12,"
						+ "'/' as excel_column_val13,"
						+ "'/' as excel_column_val14,"
						+ "detailed.net_value as excel_column_val15,"
						+ "(case when detailed.scrape_type='0' then '��������' when detailed.scrape_type='1' then '������̭' when detailed.scrape_type='2' then '����' when detailed.scrape_type='3' then '�̿�' else  '' end) as excel_column_val16,"
						+ "'/' as excel_column_val16,DUTY_UNIT excel_column_val17 from dms_scrape_detailed detailed  left join  (select dev_acc_id,asset_coding from gms_device_account union select dev_acc_id,asset_coding from  gms_device_account_b) temp  on detailed.foreign_dev_id=temp.dev_acc_id "
						+ "left join comm_org_information n on n.org_id = detailed.org_id where 1=1 "
						+ " and detailed.sp_pass_flag = '"+sp_pass_flag+"'"
						+ " and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_collect_id  = "+scrape_collect_id+")");
				list = jdbcDao.queryRecords(sql.toString());
			}
			//String excelName = "�豸��ʧ�걨��ϸ��.xls";
			String title = "";
			if("1".equals(sp_pass_flag)){
				 title = "������ͨ���豸��ʧ�걨��ϸ��.xls";
			}else{
				 title = "����ͨ���豸��ʧ�걨��ϸ��.xls";
			}
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("�豸���");
			headerList.add("�ʲ����");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("���պ�");
			headerList.add("����ʱ��");
			headerList.add("�۾�����");
			headerList.add("��ҵ��");
			headerList.add("����");
			headerList.add("����/С��");
			headerList.add("����");
			headerList.add("ԭֵ");
			headerList.add("�ۼ��۾�");
			headerList.add("��ֵ׼��");
			headerList.add("����");
			headerList.add("����ԭ��");
			headerList.add("���ε�λ");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", title);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// zjb�����ϱ���ѯ
		if ("bfsbcx".equals(exportFlag)) {
			// �������뵥��
			String scrape_report_id = msg.getValue("scrape_report_id");
			List<Map> list = new ArrayList<Map>();
			if (!"null".equals(scrape_report_id)) {
				StringBuilder sql = new StringBuilder(
						" select  "
						+ "detailed.dev_type as excel_column_val0,"
						+ "detailed.dev_coding as excel_column_val1,"
						+ "detailed.asset_coding as excel_column_val2,"
						+ "detailed.dev_name as excel_column_val3,"
						+ "detailed.dev_model as excel_column_val4,"
						+ "detailed.license_num as excel_column_val5,"
						+ "detailed.producting_date as excel_column_val6,"
						+ "case  when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '���꼰����' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '���굽����' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '���굽����' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then 'һ�굽����' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then 'һ������' else 'δ֪ʱ��' end as excel_column_val7,"
						+ "n.org_name as excel_column_val8,"
						+ "'/' as excel_column_val9,"
						+ "'/' as excel_column_val10,"
						+ "'1' as excel_column_val11,"
						+ "detailed.asset_value as excel_column_val12,"
						+ "'/' as excel_column_val13,"
						+ "'/' as excel_column_val14,"
						+ "detailed.net_value as excel_column_val15,"
						+ "(case when detailed.scrape_type='0' then '��������' when detailed.scrape_type='1' then '������̭' when detailed.scrape_type='2' then '����' when detailed.scrape_type='3' then '�̿�' else  '' end) as excel_column_val16,"
						+ "'/' as excel_column_val17 "
						+ "from dms_scrape_detailed detailed "
						+ "left join comm_org_information n on n.org_id = detailed.org_id where 1=1 and detailed.sp_pass_flag='0' "
						+ " and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_report_id  = "+scrape_report_id+")");
				list = jdbcDao.queryRecords(sql.toString());
			}
			String excelName = "�豸��ʧ�걨��ϸ��-�ϱ�.xls";
			String title = "�豸��ʧ�걨��ϸ��-�ϱ�";
			List<String> headerList = new ArrayList<String>();
			headerList.add("�豸����");
			headerList.add("�豸���");
			headerList.add("�ʲ�����");
			headerList.add("�豸����");
			headerList.add("����ͺ�");
			headerList.add("���պ�");
			headerList.add("����ʱ��");
			headerList.add("�۾�����");
			headerList.add("��ҵ��");
			headerList.add("����");
			headerList.add("����/С��");
			headerList.add("����");
			headerList.add("ԭֵ");
			headerList.add("�ۼ��۾�");
			headerList.add("��ֵ׼��");
			headerList.add("����");
			headerList.add("����ԭ��");
			headerList.add("���ε�λ");
			responseMsg.setValue("doctype", exportFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}
		// ����������ϸ
				if ("czsqmx".equals(exportFlag)) {
					// �������뵥��
					String scrape_report_id = msg.getValue("scrape_report_id");
					Map headMap = new HashMap();
					List<Map> list = new ArrayList<Map>();
					if (!"null".equals(scrape_report_id)) {
						StringBuilder sql = new StringBuilder(
								"SELECT"
								+ " detailed.dev_type AS excel_column_val0,"
								+ " detailed.dev_coding AS excel_column_val1,"
								+ " detailed.dev_name AS excel_column_val2,"
								+ " detailed.dev_model AS excel_column_val3,"
								+ " detailed.license_num AS excel_column_val4,"
								+ " TO_CHAR(detailed.producting_date,'yyyy-MM-dd') AS excel_column_val5,"
								+ " ( CASE WHEN TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') >= 8 AND TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') < 100 THEN '���꼰����' WHEN TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') >= 5 AND TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') < 8 THEN '���굽����' WHEN TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') >= 3 AND TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') < 5 THEN '���굽����' WHEN TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') >= 1 AND TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') < 3 THEN 'һ�굽����' WHEN TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') >= 0 AND TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR( detailed.producting_date, 'yyyy') < 1 THEN 'һ������' ELSE 'δ֪ʱ��' END) AS excel_column_val6,"
								+ " detailed.asset_value AS excel_column_val7,"
								+ " '/' AS excel_column_val8,"
								+ " '/' AS excel_column_val9,"
								+ " detailed.net_value AS excel_column_val10,"
								+ " ( CASE WHEN detailed.scrape_type = '0' THEN '��������' WHEN detailed.scrape_type = '1' THEN '������̭' WHEN detailed.scrape_type = '2' THEN '����' WHEN detailed.scrape_type = '3' THEN '�̿�' ELSE '' END) AS excel_column_val11,"
								+ " n.org_name AS excel_column_val12"
								+ " FROM dms_scrape_detailed detailed"
							    + " LEFT JOIN gms_device_account ACCOUNT ON ACCOUNT .dev_acc_id = detailed.foreign_dev_id"
							    + " LEFT JOIN comm_org_information n ON n.org_id = detailed.org_id"
							    + " WHERE detailed.dispose_apply_id = "
							    + scrape_report_id );
						list = jdbcDao.queryRecords(sql.toString());
						
						StringBuilder headsql = new StringBuilder("SELECT dt.sum_asset, T .*,( CASE WHEN t2.proc_status = '1' THEN '������' WHEN t2.proc_status = '3' THEN '����ͨ��' WHEN t2.proc_status = '4' THEN '������ͨ��' ELSE 'δ�ύ' END) AS apply_status, emp.employee_name, org.org_name AS org_name FROM dms_dispose_apply T LEFT JOIN common_busi_wf_middle t2 ON T .dispose_apply_id = t2.business_id AND t2.bsflag = '0' LEFT JOIN comm_human_employee emp ON T .employee_id = emp.employee_id LEFT JOIN( SELECT SUM(D .asset_value) sum_asset, dispose_apply_id FROM dms_scrape_detailed D WHERE D .dispose_apply_id IS NOT NULL GROUP BY D .dispose_apply_id) dt ON T .dispose_apply_id = dt.dispose_apply_id LEFT JOIN comm_org_information org ON T .dispose_org_id = org.org_id WHERE T .bsflag = '0' AND T .dispose_apply_id ="
						 		+ scrape_report_id);
						headMap = jdbcDao.queryRecordBySQL(headsql.toString());
					}
					String excelName = "�豸����������ϸ��.xls";
					String title = "�豸����������ϸ��";
					List<String> headerList = new ArrayList<String>();
					headerList.add("�ʲ�����");
					headerList.add("�豸���");
					headerList.add("�豸����");
					headerList.add("����ͺ�");
					headerList.add("���պ�");
					headerList.add("����ʱ��");
					headerList.add("�۾�����");
					headerList.add("ԭֵ");
					headerList.add("�ۼ��۾�");
					headerList.add("��ֵ׼��");
					headerList.add("����");
					headerList.add("����ԭ��");
					headerList.add("��ҵ��");
					responseMsg.setValue("doctype", exportFlag);
					responseMsg.setValue("excelName", excelName);
					responseMsg.setValue("excelHeader", headerList);
					responseMsg.setValue("excelData", list);
					responseMsg.setValue("headMap", headMap);
				}
		return responseMsg;
	}

	/**
	 * ��ȡ��Ŀ����
	 * 
	 * @param projectInfoNo
	 * @return
	 */
	public String getProjectName(String projectInfoNo, String insName) {
		String sql = "select t.project_name from gp_task_project t where t.bsflag='0' and t.project_info_no='"
				+ projectInfoNo + "'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if (MapUtils.isNotEmpty(map)) {
			return map.get("project_name").toString();
		}
		return insName;
	}

	/**
	 * ��ȡ��������
	 * 
	 * @param code
	 * @return
	 */
	public String getCodeName(String code) {
		String sql = "select coding_name from comm_coding_sort_detail where coding_code_id='"
				+ code + "'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if (MapUtils.isNotEmpty(map)) {
			return map.get("coding_name").toString();
		}
		return "";
	}

	/**
	 * ��ȡ��̽������
	 * 
	 * @param code
	 * @return
	 */
	public String getOrgName(String orgsubId) {
		String sql = "select org_abbreviation as orgname from comm_org_information org "
				+ "left join comm_org_subjection suborg on org.org_id=suborg.org_id and suborg.bsflag='0' "
				+ "where suborg.org_subjection_id='" + orgsubId + "'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if (MapUtils.isNotEmpty(map)) {
			return map.get("orgname").toString();
		}
		return "";
	}

	/**
	 * ����id��ѯ�豸�����ϸ��Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectYear(ISrvMsg isrvmsg) throws Exception {
		log.info("getProjectYear");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String sql = " select pro.project_year from gp_task_project pro where pro.bsflag='0' and pro.project_year is not null "
				+ " group by pro.project_year order by  pro.project_year desc";
		List<Map> list = jdbcDao.queryRecords(sql);
		responseDTO.setValue("data", list);
		return responseDTO;
	}

	/**
	 * NEWMETHOD �����������ձ�����Ϣ--����첨��
	 * 
	 * @param msg
	 * @returnsaveEQBatchMixFormDetailInfo
	 * @throws Exception
	 */

	public ISrvMsg saveHireFillDetailInfo(ISrvMsg msg) throws Exception {
		// 1.��û�����Ϣ
		String project_info_no = msg.getValue("project_info_no");
		String device_app_detid = msg.getValue("deviceappdetid");
		// 2.�û���ʱ����Ϣ
		UserToken user = msg.getUserToken();
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// 3.���ڴ�����ϸ��Ϣ�Ķ�ȡ
		int count = Integer.parseInt(msg.getValue("count"));
		int checknum = Integer.parseInt(msg.getValue("checknum"));// �ѵ�������

		// ��ѯ�����������ѵ�������
		Map<String, Object> hirMap = jdbcDao
				.queryRecordBySQL("select nvl(apply_num,0) as apply_num ,nvl(mix_num,0) as mix_num from gms_device_hireapp_detail t where t.device_app_detid = '"
						+ device_app_detid + "'");
		int apply_num = Integer.parseInt(hirMap.get("apply_num").toString());
		int mix_num = Integer.parseInt(hirMap.get("mix_num").toString());
		int recevie_num = Integer.parseInt(msg.getValue("mix_num0").toString());
		mix_num = mix_num + recevie_num;
		// �ɼ��豸ID
		String deviceId = msg.getValue("detdev_ci_code0");
		Map<String, Object> devMap = jdbcDao
				.queryRecordBySQL("select TOTAL_NUM,UNUSE_NUM,DEV_ACC_ID from GMS_DEVICE_COLL_ACCOUNT_DUI  dui where dui.is_leaving='0' and dui.account_stat='0110000013000000005' and dui.usage_org_id='"
						+ user.getOrgId()
						+ "' and dui.fk_device_appmix_id='"
						+ device_app_detid
						+ "'  and  dui.device_id ='"
						+ deviceId + "'");
		if (devMap != null) {
			int totalNum = Integer.parseInt(devMap.get("total_num").toString())
					+ recevie_num;
			int unuseNum = Integer.parseInt(devMap.get("unuse_num").toString())
					+ recevie_num;
			Map<String, Object> dataMap = new HashMap<String, Object>();
			// ʵ�ʽ���ʱ��
			dataMap.put("actual_in_time", msg.getValue("realstartdate0"));
			dataMap.put("TOTAL_NUM", totalNum + "");
			dataMap.put("UNUSE_NUM", unuseNum + "");
			dataMap.put("modifier", user.getEmpId());
			dataMap.put("dev_acc_id", devMap.get("dev_acc_id").toString());
			// �û���Ϣ���޸�ʱ��
			dataMap.put("modifier", user.getEmpId());
			dataMap.put("modifi_date", currentdate);
			Serializable id = jdbcDao.saveOrUpdateEntity(dataMap,
					"GMS_DEVICE_COLL_ACCOUNT_DUI");

			Map<String, Object> Map_dymInfo = new HashMap<String, Object>();
			Map_dymInfo.put("dev_acc_id", id.toString());
			Map_dymInfo.put("oprtype", "1");
			Map_dymInfo.put("CREATOR", user.getEmpId());
			Map_dymInfo.put("CREATE_DATE", currentdate);
			Map_dymInfo.put("RECEIVE_NUM", recevie_num + "");
			// �ƻ�����ʱ��
			Map_dymInfo.put("planning_in_time", msg.getValue("startdate0"));
			// �ƻ��볡ʱ��
			Map_dymInfo.put("planning_out_time", msg.getValue("enddate0"));
			// ʵ�ʽ���ʱ��
			Map_dymInfo.put("actual_in_time", msg.getValue("realstartdate0"));
			jdbcDao.saveOrUpdateEntity(Map_dymInfo,
					"GMS_DEVICE_COLL_ACCOUNT_DYM");

		} else {
			for (int i = 0; i < 1; i++) {
				Map<String, Object> dataMap = new HashMap<String, Object>();
				// TODO ���Ϊ�޸Ĳ�������ôʹ��dev_acc_id
				String search_id = UUID.randomUUID().toString()
						.replaceAll("-", "");
				dataMap.put("search_id", search_id);
				// ɾ�����
				dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);

				// �ɼ��豸ID
				dataMap.put("device_id", msg.getValue("detdev_ci_code" + i));
				// �豸����
				String dev_name = msg.getValue("detdev_ci_name" + i);
				dataMap.put("dev_name", dev_name);
				dataMap.put("dev_ci_name", dev_name);
				// ����ͺ�
				String dev_model = msg.getValue("detdev_ci_model" + i);
				dataMap.put("dev_model", dev_model);
				dataMap.put("dev_ci_model", dev_model);
				// ���ⵥ��
				String rentalprice = msg.getValue("devrental" + i);
				dataMap.put("rentalprice", rentalprice);
				dataMap.put("devrental", rentalprice);
				// ������λ
				String ownorgname = msg.getValue("ownorgname" + i);
				String ownorgid = msg.getValue("ownorgid" + i);
				dataMap.put("owning_org_name", ownorgname);
				dataMap.put("owning_org_id", ownorgid);
				String usageorgname = msg.getValue("usageorgname" + i);
				String usageorgid = msg.getValue("usageorgid" + i);
				dataMap.put("usage_org_name", usageorgname);
				dataMap.put("usage_org_id", usageorgid);
				// ������λ
				dataMap.put("DEV_UNIT", msg.getValue("unitinfo"));
				// ת�뵥λID
				dataMap.put("IN_ORG_ID", ownorgid);
				// ������
				dataMap.put("total_num", recevie_num);
				// �ڶ�����
				System.out.println("1�豸������=-----" + recevie_num);
				dataMap.put("unuse_num", recevie_num);
				// �������
				dataMap.put("use_num", "0");
				// �ʲ�״̬Ϊ ����
				dataMap.put("account_stat", msg.getValue("account_stat" + i));
				// �û���Ϣ���޸�ʱ��
				dataMap.put("CREATOR", user.getEmpId());
				// �ƻ�����ʱ��
				dataMap.put("planning_in_time", msg.getValue("startdate" + i));
				// �ƻ��볡ʱ��
				dataMap.put("planning_out_time", msg.getValue("enddate" + i));
				// ʵ�ʽ���ʱ��
				dataMap.put("actual_in_time", msg.getValue("realstartdate" + i));
				// ��ĿID
				dataMap.put("PROJECT_INFO_ID", project_info_no);
				// �������䵥ID
				dataMap.put("FK_DEVICE_APPMIX_ID", device_app_detid);
				// �ʲ�״̬
				dataMap.put("ACCOUNT_STAT", msg.getValue("account_stat" + i));
				// Ĭ��Ϊδ�볡
				dataMap.put("is_leaving", "0");
				dataMap.put("CREATE_DATE", currentdate);
				// 4. �ȱ��湫˾��̨��
				Serializable id = jdbcDao.saveOrUpdateEntity(dataMap,
						"GMS_DEVICE_COLL_ACCOUNT_DUI");

				Map<String, Object> Map_dymInfo = new HashMap<String, Object>();
				Map_dymInfo.put("dev_acc_id", id.toString());
				Map_dymInfo.put("oprtype", "1");
				Map_dymInfo.put("CREATOR", user.getEmpId());
				Map_dymInfo.put("CREATE_DATE", currentdate);
				Map_dymInfo.put("RECEIVE_NUM", recevie_num + "");
				// �ƻ�����ʱ��
				Map_dymInfo.put("planning_in_time", msg.getValue("startdate0"));
				// �ƻ��볡ʱ��
				Map_dymInfo.put("planning_out_time", msg.getValue("enddate0"));
				// ʵ�ʽ���ʱ��
				Map_dymInfo.put("actual_in_time",
						msg.getValue("realstartdate0"));
				jdbcDao.saveOrUpdateEntity(Map_dymInfo,
						"GMS_DEVICE_COLL_ACCOUNT_DYM");
			}

		}
		String tempSql = "";
		// ���������������жϴ���״̬
		if (mix_num == apply_num) {
			tempSql = "update gms_device_hireapp_detail set state='1' where device_app_detid='"
					+ device_app_detid + "'";
		} else if (mix_num < apply_num && mix_num != 0) {
			tempSql = "update gms_device_hireapp_detail set state='2' where device_app_detid='"
					+ device_app_detid + "'";
		}

		jdbcDao.executeUpdate("update gms_device_hireapp_detail set mix_num="
				+ mix_num + " where device_app_detid='" + device_app_detid
				+ "'");
		if (tempSql != "") {
			jdbcDao.executeUpdate(tempSql);
		}

		// ����������ϸ����������������뵥����
		Map<String, Object> hireMap = jdbcDao
				.queryRecordBySQL("select appdet.device_hireapp_id from gms_device_hireapp_detail appdet where appdet.device_app_detid='"
						+ device_app_detid + "'");
		// ������Ҫ������ϸ������������״̬�����������뵥�Ĵ���״̬
		String querySql = "select count(*) as sum from gms_device_hireapp_detail appdet    where appdet.project_info_no ='"
				+ project_info_no
				+ "'  and appdet.device_hireapp_id ='"
				+ hireMap.get("device_hireapp_id")
				+ "'  and appdet.bsflag = '0'";
		// ��ȡ���ⵥ��Ҫ���յ�����
		Map<String, Object> sumMap = jdbcDao.queryRecordBySQL(querySql);
		// ��ȡ���ⵥ����������
		Map<String, Object> wanMap = jdbcDao
				.queryRecordBySQL("select count(*) as sum from gms_device_hireapp_detail appdet    where appdet.project_info_no ='"
						+ project_info_no
						+ "'  and appdet.device_hireapp_id ='"
						+ hireMap.get("device_hireapp_id")
						+ "' and appdet.state='1'  and appdet.bsflag = '0' ");
		// ��ȡ���ⵥ�������յ�����
		Map<String, Object> nowMap = jdbcDao
				.queryRecordBySQL("select count(*) as sum from gms_device_hireapp_detail appdet    where appdet.project_info_no ='"
						+ project_info_no
						+ "'  and appdet.device_hireapp_id ='"
						+ hireMap.get("device_hireapp_id")
						+ "' and appdet.state='2'  and appdet.bsflag = '0' ");
		if (sumMap != null && wanMap != null && nowMap != null) {
			// �����ǰ������豸��δ���ա���������
			// �����ǰ������豸δ��������С����Ҫ���յ�����
			if (Integer.parseInt(nowMap.get("sum").toString()) > 0) {
				// �������뵥����״̬Ϊ������
				String Sql = " update gms_device_hireapp set OPR_STATE='1' where DEVICE_HIREAPP_ID='"
						+ hireMap.get("device_hireapp_id") + "'";
				jdbcDao.executeUpdate(Sql);
			}
			// ״̬Ϊ������
			else if (Integer.parseInt(wanMap.get("sum").toString()) != 0
					&& Integer.parseInt(wanMap.get("sum").toString()) < Integer
							.parseInt(sumMap.get("sum").toString())) {
				// �������뵥����״̬Ϊ������
				String Sql = " update gms_device_hireapp set OPR_STATE='1' where DEVICE_HIREAPP_ID='"
						+ hireMap.get("device_hireapp_id") + "'";
				jdbcDao.executeUpdate(Sql);
			}
			// �����ǰ��δ���յ��豸��¼��Ϊ0���������뵥״̬Ϊ������
			else if (Integer.parseInt(wanMap.get("sum").toString()) == Integer
					.parseInt(sumMap.get("sum").toString())) {

				// �������뵥����״̬Ϊ������
				String Sql = " update gms_device_hireapp set OPR_STATE='9' where DEVICE_HIREAPP_ID='"
						+ hireMap.get("device_hireapp_id") + "'";
				jdbcDao.executeUpdate(Sql);
			} else {
				// �������뵥����״̬Ϊδ����
				String Sql = " update gms_device_hireapp set OPR_STATE='0' where DEVICE_HIREAPP_ID='"
						+ hireMap.get("device_hireapp_id") + "'";
				jdbcDao.executeUpdate(Sql);
			}

		}
		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}

	/**
	 * NEWMETHOD ���������豸(�첨��)�볡����Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRentDevLeftInfo(ISrvMsg msg) throws Exception {
		// 1.��û�����Ϣ
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String is_leaving = DevConstants.DEVLEAVING_YES;
		String bsflag = DevConstants.BSFLAG_DELETE;
		String project_info_no = msg.getValue("project_info_no");
		Map<String, Object> dataMap = new HashMap<String, Object>();
		// �������
		dataMap.put("use_num", msg.getValue("unuse_num") == null ? 0 + "" : msg
				.getValue("unuse_num").toString());
		// �ڶ�����
		dataMap.put("unuse_num", "0");
		dataMap.put("dev_acc_id", msg.getValue("dev_acc_id"));
		dataMap.put("actual_out_time", msg.getValue("actual_out_time"));
		dataMap.put("is_leaving", is_leaving);
		dataMap.put("modifi_date", currentdate);

		jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_coll_account_dui");

		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}

	/**
	 * NEWMETHOD �޸������豸(�첨��)�볡����Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateRentDevLeftInfo(ISrvMsg msg) throws Exception {
		// 1.��û�����Ϣ
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String is_leaving = DevConstants.DEVLEAVING_YES;
		String bsflag = DevConstants.BSFLAG_DELETE;
		String project_info_no = msg.getValue("project_info_no");
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("dev_acc_id", msg.getValue("dev_acc_id"));
		dataMap.put("actual_out_time", msg.getValue("actual_out_time"));
		dataMap.put("modifi_date", currentdate);

		jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_coll_account_dui");

		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}

	/**
	 * ����ҳ���ʼ��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevDatas(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String userOrg = user.getSubOrgIDofAffordOrg();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("ids");
		List<Map> list = new ArrayList<Map>();
		String str = "select aa.* from (select  (case when nvl(t.mileage, -1) >= nvl(plan.mileage, 0) then  'red'   else   (case  when nvl(t.work_hour, -1) >=";
		str += " nvl(plan.work_hour, 0) then  'red'  else (case  when nvl(t.drilling_footage, -1) >=  nvl(plan.drilling_footage, 0) then  'red'";
		str += " 	 else    (case  when to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') >=nvl(( select plan_date from gms_device_maintenance_plan p where p.plan_num=1 and p.dev_acc_id=t.dev_acc_id),to_date(to_char(sysdate+1,'yyyy-mm-dd'),'yyyy-mm-dd'))";
		str += "  then  'red'  else  (case  when  (select count(*) from gms_device_maintenance_plan w where w.dev_acc_id=t.dev_acc_id)+   (select count(*) from gms_device_maintenance_unplan p where p.dev_acc_id=t.dev_acc_id )  <=0 ";
		str += " 	 then  'yellow'   else  'green'  end)   end)  end) end) end) as info,  ";
		str += "  nvl(t.ifcountry, '����') as ifcountry_tmp,    (select coding_name";
		str += "   from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,";
		str += "  t.*, t.dev_coding as erp_id,     (case   when t.owning_sub_id like 'C105001005%' then   '����ľ��̽��'   else";
		str += " (case   when t.owning_sub_id like 'C105001002%' then   '�½���̽��'";
		str += " else     (case   when t.owning_sub_id like 'C105001003%' then   '�¹���̽��'";
		str += " else   (case  when t.owning_sub_id like 'C105001004%' then  '�ຣ��̽��'";
		str += " else    (case   when t.owning_sub_id like 'C105005004%' then  '������̽��'";
		str += " else    (case  when t.owning_sub_id like 'C105005000%' then      '������̽��'";
		str += " else (case  when t.owning_sub_id like 'C105005001%' then  '������̽������'";
		str += " else (case  when t.owning_sub_id like 'C105007%' then  '�����̽��'";
		str += " else   (case  when t.owning_sub_id like 'C105063%' then '�ɺ���̽��'";
		str += " else  (case when t.owning_sub_id like 'C105006%' then  'װ������'";
		str += " else (case when t.owning_sub_id like 'C105002%' then  '���ʿ�̽��ҵ��'";
		str += " else   (case  when t.owning_sub_id like 'C105003%' then  '�о�Ժ'";
		str += " else (case  when t.owning_sub_id like 'C105008%' then '�ۺ��ﻯ��'";
		str += " else   (case  when t.owning_sub_id like 'C105015%' then  '���е�������'";
		str += " else (case  when t.owning_sub_id like 'C105017%' then  '����������ҵ��'";
		str += " else  ''  end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc,";
		str += " i.org_abbreviation usage_org_name_desc,  (select coding_name from comm_coding_sort_detail co";
		str += " where co.coding_code_id = t.account_stat) as account_stat_desc  from gms_device_account_unpro t";
		str += " inner join(comm_org_subjection s  inner join comm_org_information org on s.org_id = org.org_id) on t.owning_sub_id = s.org_subjection_id";
		str += " left join comm_org_information i on t.usage_org_id = i.org_id   and i.bsflag = '0'";
		str += " left join gms_device_maintenance_unplan plan on plan.dev_acc_id=t.dev_acc_id";
		str += " where t.bsflag = '0' and t.is_leaving='0'  and t.owning_sub_id like '"
				+ userOrg + "%' ) aa ";
		list = pureJdbcDao.queryRecords(str);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * ͬ��erp�豸
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg toSyncErpLocalDev(ISrvMsg reqDTO) throws Exception {
		String erpDeviceId = reqDTO.getValue("erpDeviceId");
		String localDeviceId = reqDTO.getValue("localDeviceId");

		String delLocalDev = "";
		String upErpDev = "";
		String upDuiDev = "";
		String devposition = "";
		if (localDeviceId != null && !"".equals(localDeviceId)) {
			String sqlLocal = "select acc.dev_position,acc.usage_org_id,acc.usage_sub_id,acc.using_stat,acc.project_info_no,acc.saveflag,acc.check_time,acc.search_id ";
			sqlLocal += "from gms_device_account acc where acc.dev_acc_id='"
					+ localDeviceId + "' ";
			Map<String, Object> accLocMap = jdbcDao.queryRecordBySQL(sqlLocal);
			if (accLocMap != null) {
				devposition = (String) accLocMap.get("dev_position");// ��ŵ�
				// ɾ���ֹ�¼����豸
				delLocalDev = "delete from gms_device_account t where t.dev_acc_id = '"
						+ localDeviceId + "' ";
				jdbcDao.executeUpdate(delLocalDev);

				// ����erpͬ���������豸
				upErpDev = "update gms_device_account t set t.bsflag='0',t.dev_acc_id='"
						+ localDeviceId
						+ "', "
						+ "t.usage_org_id='"
						+ (String) accLocMap.get("usage_org_id")
						+ "', "
						+ "t.usage_sub_id='"
						+ (String) accLocMap.get("usage_sub_id")
						+ "', "
						+ "t.using_stat='"
						+ (String) accLocMap.get("using_stat")
						+ "', "
						+ "t.project_info_no='"
						+ (String) accLocMap.get("project_info_no")
						+ "', "
						+ "t.saveflag='"
						+ (String) accLocMap.get("saveflag")
						+ "', ";

				if (devposition != null && !"".equals(devposition)) {
					upErpDev += "t.dev_position='" + devposition + "', ";
				}

				upErpDev += "t.check_time=to_date('"
						+ (String) accLocMap.get("check_time")
						+ "','yyyy-mm-dd')," + "t.search_id='"
						+ (String) accLocMap.get("search_id") + "' "
						+ "where t.bsflag='I' and t.dev_acc_id='" + erpDeviceId
						+ "' ";
				jdbcDao.executeUpdate(upErpDev);
			}

			// ���¶Ӽ��豸̨��
			String sqlErp = "select * from gms_device_account acc where acc.dev_acc_id='"
					+ localDeviceId + "' ";
			Map<String, Object> accErpMap = jdbcDao.queryRecordBySQL(sqlErp);
			if (accErpMap != null) {
				upDuiDev = "update gms_device_account_dui dui set dui.dev_coding='"
						+ (String) accErpMap.get("dev_coding")
						+ "', "
						+ "dui.dev_name='"
						+ (String) accErpMap.get("dev_name")
						+ "', "
						+ "dui.asset_stat='"
						+ (String) accErpMap.get("asset_stat")
						+ "', "
						+ "dui.dev_model='"
						+ (String) accErpMap.get("dev_model")
						+ "', "
						+ "dui.self_num='"
						+ (String) accErpMap.get("self_num")
						+ "', "
						+ "dui.dev_sign='"
						+ (String) accErpMap.get("dev_sign")
						+ "', "
						+ "dui.dev_type='"
						+ (String) accErpMap.get("dev_type")
						+ "', "
						+ "dui.dev_unit='"
						+ (String) accErpMap.get("dev_unit")
						+ "', "
						+ "dui.asset_coding='"
						+ (String) accErpMap.get("asset_coding")
						+ "', "
						+ "dui.turn_num='"
						+ (String) accErpMap.get("turn_num")
						+ "', "
						+ "dui.order_num='"
						+ (String) accErpMap.get("order_num")
						+ "', "
						+ "dui.requ_num='"
						+ (String) accErpMap.get("requ_num")
						+ "', "
						+ "dui.asset_value='"
						+ (String) accErpMap.get("asset_value")
						+ "', "
						+ "dui.net_value='"
						+ (String) accErpMap.get("net_value")
						+ "', "
						+ "dui.cont_num='"
						+ (String) accErpMap.get("cont_num")
						+ "', "
						+ "dui.currency='"
						+ (String) accErpMap.get("currency")
						+ "', "
						+ "dui.tech_stat='"
						+ (String) accErpMap.get("tech_stat")
						+ "', "
						+ "dui.capital_source='"
						+ (String) accErpMap.get("capital_source")
						+ "', "
						+ "dui.owning_org_id='"
						+ (String) accErpMap.get("owning_org_id")
						+ "', "
						+ "dui.owning_org_name='"
						+ (String) accErpMap.get("owning_org_name")
						+ "', "
						+ "dui.owning_sub_id='"
						+ (String) accErpMap.get("owning_sub_id")
						+ "', "
						+ "dui.usage_org_id='"
						+ (String) accErpMap.get("usage_org_id")
						+ "', "
						+ "dui.usage_org_name='"
						+ (String) accErpMap.get("usage_org_name")
						+ "', "
						+ "dui.usage_sub_id='"
						+ (String) accErpMap.get("usage_sub_id")
						+ "', "
						+ "dui.manu_factur='"
						+ (String) accErpMap.get("manu_factur")
						+ "', "
						+ "dui.producting_date=to_date('"
						+ (String) accErpMap.get("producting_date")
						+ "','yyyy-mm-dd'), "
						+ "dui.account_stat='"
						+ (String) accErpMap.get("account_stat")
						+ "', "
						+ "dui.license_num='"
						+ (String) accErpMap.get("license_num")
						+ "', "
						+ "dui.chassis_num='"
						+ (String) accErpMap.get("chassis_num")
						+ "', "
						+ "dui.engine_num='"
						+ (String) accErpMap.get("engine_num")
						+ "', "
						+ "dui.remark='"
						+ (String) accErpMap.get("remark")
						+ "' "
						+ "where dui.fk_dev_acc_id='"
						+ localDeviceId
						+ "' ";
				jdbcDao.executeUpdate(upDuiDev);
			}
		} else {
			// ����erpͬ���������豸
			upErpDev = "update gms_device_account t set t.bsflag='0' where t.bsflag='I' and t.dev_acc_id='"
					+ erpDeviceId + "' ";
			jdbcDao.executeUpdate(upErpDev);
		}

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		return reqDTO;
	}

	/**
	 * �ۺ��ﻯ̽���²�����Ա״̬
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg toUpDevOperator(ISrvMsg reqDTO) throws Exception {
		String mix_info_id = reqDTO.getValue("mixinfoid");

		if (mix_info_id != null && !"".equals(mix_info_id)) {
			String upErpDev = "update gms_device_mixinfo_form set state='9' where device_mixinfo_id = '"
					+ mix_info_id + "' ";
			jdbcDao.executeUpdate(upErpDev);

			/*
			 * String opersql =
			 * "select amd.operator_id from gms_device_appmix_detail amd " +
			 * "left join gms_device_appmix_main amm on amd.device_mix_subid = amm.device_mix_subid "
			 * +
			 * "left join gms_device_mixinfo_form mif on amm.device_mixinfo_id = mif.device_mixinfo_id "
			 * + "where mif.device_mixinfo_id ='"+mix_info_id+"' "; List<Map>
			 * operResult = jdbcDao.queryRecords(opersql); for(int
			 * i=0;i<operResult.size();i++){ String operatorid = (String)
			 * operResult.get(i).get("operator_id"); //�ж��Ƿ�Ϊ��ͬ�� String sqlHr =
			 * "select 1 from comm_human_employee_hr hr where hr.bsflag = '0' and hr.employee_id ='"
			 * +operatorid+"' "; Map<String,Object> accHrMap =
			 * jdbcDao.queryRecordBySQL(sqlHr); if(accHrMap!=null){
			 * jdbcDao.executeUpdate(
			 * "update comm_human_employee_hr set person_status='1',deploy_status='2',modifi_date=sysdate where employee_id = '"
			 * +operatorid+"' "); }else{ //�ж��Ƿ�Ϊ��ʱ�� String sqlLabor =
			 * "select 1 from bgp_comm_human_labor hr where hr.bsflag = '0' and hr.labor_id ='"
			 * +operatorid+"' "; Map<String,Object> accLaborMap =
			 * jdbcDao.queryRecordBySQL(sqlLabor); if(accLaborMap!=null){
			 * jdbcDao.executeUpdate(
			 * "update bgp_comm_human_labor d set d.if_project = '1', spare1='2',d.modifi_date=sysdate where d.labor_id = '"
			 * +operatorid+"' "); } } }
			 */
		}

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		return reqDTO;
	}

	/**
	 * �������޸ı�����Ϣ--����Ŀ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateBJ(ISrvMsg reqDTO) throws Exception {
		log.info("saveBJ");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String recyclemat_info = reqDTO.getValue("recyclemat_info");
		String wz_sequence = reqDTO.getValue("wz_sequence");
		String orgSubjectionId = user.getOrgSubjectionId();
		String project_info_id = user.getProjectInfoNo();
		String orgId = user.getOrgId();
		Map reqmap = reqDTO.toMap();
		String sql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
				+ reqmap.get("wz_id")
				+ "'  and t.bsflag='0' and t.wz_type='3'  and t.project_info_id='"
				+ project_info_id + "'";
		Map getMap = jdbcDao.queryRecordBySQL(sql);
		if (getMap != null && orgSubjectionId.trim().length() > 0) {
			orgSubjectionId = getMap.get("org_subjection_id").toString();
		}
		// ����
		double stockNum = Double.valueOf(reqmap.get("stock_num") == "" ? "0"
				: reqmap.get("stock_num").toString());
		double total_num = stockNum;
		Map map = new HashMap();
		// if(reqmap.get("recyclemat_info").toString().equals("")){
		if (getMap != null) {
			// stockNum += Double.valueOf(getMap.get("stock_num")== "" ? "0" :
			// getMap.get("stock_num").toString());
			// total_num += Double.valueOf(getMap.get("total_num")== "" ? "0" :
			// getMap.get("total_num").toString());

			// ����
			// double actual_price = Double.valueOf(getMap.get("actual_price")==
			// "" ? "0" : getMap.get("actual_price").toString());
			// �������*��浥��+��������*��������/������
			// double avg_price = ((Double.valueOf(reqmap.get("actual_price") ==
			// "" ? "0" : reqmap.get("actual_price").toString()) *
			// Double.valueOf(reqmap.get("stock_num")==""?"0":reqmap.get("stock_num").toString()))
			// + (Double.valueOf(getMap.get("stock_num")== "" ? "0" :
			// getMap.get("stock_num").toString())*Double.valueOf(getMap.get("actual_price")==
			// "" ? "0" :
			// getMap.get("actual_price").toString())))/(stockNum==0?1:stockNum);
			double stockNumbefore = Double
					.valueOf(getMap.get("stock_num") == "" ? "0" : getMap.get(
							"stock_num").toString());
			stockNum = stockNum + stockNumbefore;
			map.put("recyclemat_info", getMap.get("recyclemat_info"));
			map.put("actual_price", reqmap.get("actual_price"));
			map.put("stock_num", stockNum);
		} else {
			map.put("create_date", new Date());
			map.put("creator_id", user.getUserId());
			map.put("actual_price", reqmap.get("actual_price"));
			map.put("stock_num", stockNum);
		}
		// }
		map.put("wz_sequence", wz_sequence);
		map.put("wz_id", reqmap.get("wz_id"));
		map.put("total_num", total_num);
		map.put("wz_type", "3");
		map.put("org_id", orgId);
		// map.put("org_subjection_id", orgSubjectionId);
		map.put("modifi_date", new Date());
		map.put("updator_id", user.getUserId());
		map.put("PROJECT_INFO_ID", user.getProjectInfoNo());
		map.put("bsflag", "0");
		jdbcDao.saveOrUpdateEntity(map, "gms_mat_recyclemat_info");

		return reqMsg;
	}

	/**
	 * �������޸ı�����Ϣ--����Ŀ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateBJs(ISrvMsg reqDTO) throws Exception {
		log.info("saveBJ");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String recyclemat_info = reqDTO.getValue("recyclemat_info");
		String wz_sequence = reqDTO.getValue("wz_sequence");
		String orgSubjectionId = user.getOrgSubjectionId();
		String orgId = user.getOrgId();
		Map reqmap = reqDTO.toMap();
		String sql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
				+ reqmap.get("wz_id")
				+ "'  and t.bsflag='0'  and t.wz_type='3'  and t.org_subjection_id='"
				+ orgSubjectionId + "' and t.project_info_id is null ";
		Map getMap = jdbcDao.queryRecordBySQL(sql);
		if (getMap != null && orgSubjectionId.trim().length() > 0) {
			orgSubjectionId = getMap.get("org_subjection_id").toString();
		}
		// ����
		double stockNum = Double.valueOf(reqmap.get("stock_num") == "" ? "0"
				: reqmap.get("stock_num").toString());
		double total_num = stockNum;
		Map map = new HashMap();
		// if(reqmap.get("recyclemat_info").toString().equals("")){
		if (getMap != null) {
			// stockNum += Double.valueOf(getMap.get("stock_num")== "" ? "0" :
			// getMap.get("stock_num").toString());
			// total_num += Double.valueOf(getMap.get("total_num")== "" ? "0" :
			// getMap.get("total_num").toString());

			// ����
			// double actual_price = Double.valueOf(getMap.get("actual_price")==
			// "" ? "0" : getMap.get("actual_price").toString());
			// �������*��浥��+��������*��������/������
			// double avg_price = ((Double.valueOf(reqmap.get("actual_price") ==
			// "" ? "0" : reqmap.get("actual_price").toString()) *
			// Double.valueOf(reqmap.get("stock_num")==""?"0":reqmap.get("stock_num").toString()))
			// + (Double.valueOf(getMap.get("stock_num")== "" ? "0" :
			// getMap.get("stock_num").toString())*Double.valueOf(getMap.get("actual_price")==
			// "" ? "0" :
			// getMap.get("actual_price").toString())))/(stockNum==0?1:stockNum);
			double stockNumbefore = Double
					.valueOf(getMap.get("stock_num") == "" ? "0" : getMap.get(
							"stock_num").toString());
			stockNum = stockNum + stockNumbefore;
			map.put("recyclemat_info", getMap.get("recyclemat_info"));
			map.put("actual_price", reqmap.get("actual_price"));

			map.put("stock_num", stockNum);
		} else {
			map.put("create_date", new Date());
			map.put("creator_id", user.getUserId());
			map.put("actual_price", reqmap.get("actual_price"));
			map.put("stock_num", stockNum);
		}
		// }
		map.put("wz_sequence", wz_sequence);
		map.put("wz_id", reqmap.get("wz_id"));
		map.put("total_num", total_num);
		map.put("wz_type", "3");
		map.put("org_id", orgId);
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("modifi_date", new Date());
		map.put("updator_id", user.getUserId());
		map.put("org_id", user.getOrgId());
		map.put("bsflag", "0");
		jdbcDao.saveOrUpdateEntity(map, "gms_mat_recyclemat_info");

		return reqMsg;
	}

	/**
	 * ��ѯ������Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevBjList(ISrvMsg isrvmsg) throws Exception {

		UserToken user = isrvmsg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
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
		StringBuffer sqlBuffer = new StringBuffer();
		String querySql = "select * from GMS_DEVICE_BJGL where  projectinfono='"
				+ projectInfoNo + "' and bsflag=0  ";
		sqlBuffer.append(querySql);
		String s_wz_name = isrvmsg.getValue("wz_name");
		String s_wz_code = isrvmsg.getValue("wz_code");
		if (null != s_wz_name && (!"".equals(s_wz_name))) {
			sqlBuffer.append("  and wz_name like '%" + s_wz_name + "%'");
		}
		if (null != s_wz_code && (!"".equals(s_wz_code))) {
			sqlBuffer.append("  and wz_code like '%" + s_wz_code + "%'");
		}

		page = pureJdbcDao.queryRecordsBySQL(sqlBuffer.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * ��ѯ(ID)������Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevBjById(ISrvMsg isrvmsg) throws Exception {

		UserToken user = isrvmsg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer sqlBuffer = new StringBuffer();
		String bj_id = isrvmsg.getValue("bj_id");
		String querySql = "select wz_name,wz_code,wz_price,wz_prickie,actual_price,stock_num,bj_desc,note,serial_code from GMS_DEVICE_BJGL where  projectinfono='"
				+ projectInfoNo + "' and  bsflag=0 and  bj_id='" + bj_id + "'";
		Map bjMap = this.jdbcDao.queryRecordBySQL(querySql);
		responseDTO.setValue("data", bjMap);
		return responseDTO;
	}

	/**
	 * ɾ��������Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteBJById(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteBJById");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";

		String ids = isrvmsg.getValue("bj_id");
		String[] idStrings = ids.split(",");
		Date date = new Date();
		try {
			for (String id : idStrings) {

				String updateSql = "update GMS_DEVICE_BJGL set bsflag=1,updator='"
						+ user.getEmpId() + "' where bj_id='" + id + "'";
				jdbcDao.executeUpdate(updateSql);

			}
		} catch (Exception e) {
			operationFlag = "failed";
		}

		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}

	/**
	 * ����excel�������ݿⵥ��Ŀ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveExcelBJ(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		// ���excel��Ϣ
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = getBJExcelDataByWSFile(file, projectInfoId);
			}
			// ����dataList���������ݿ�
			for (int i = 1; i < dataList.size(); i++) {
				Map dataMap = (Map) dataList.get(i);
				Object bj_id = dataMap.get("bj_id");
				Date date = new Date();
				dataMap.put("bsflag", "0");
				dataMap.put("projectInfoNo", projectInfoId);
				dataMap.put("updator", user.getUserId());
				dataMap.put("modifi_date", date);
				if (null == bj_id) {
					dataMap.put("createor", user.getUserId());
					dataMap.put("create_date", date);
				}

				this.jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_bjgl");
			}
		}
		return reqMsg;
	}

	private List getBJExcelDataByWSFile(WSFile file, String projectInfoId)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		Workbook book = null;
		if (file.getFilename().endsWith(".xlsx")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			book = new XSSFWorkbook(is);
		} else {
			if (file.getFilename().endsWith(".xls")) {
				InputStream is = new ByteArrayInputStream(file.getFileData());
				book = new HSSFWorkbook(is);
			}
		}
		Sheet sheet0 = book.getSheetAt(0);
		int rows = sheet0.getPhysicalNumberOfRows();
		Row row0 = sheet0.getRow(0);
		int columns = row0.getPhysicalNumberOfCells();
		for (int m = 1; m < rows; m++) {
			Row row = sheet0.getRow(m);

			Map mapColumnInfoIn = new HashMap();
			for (int n = 0; n < columns; n++) {
				Cell cell = row.getCell(n);
				int cellType = cell.getCellType();
				switch (cellType) {
				case 0:
					cell.setCellType(cell.CELL_TYPE_STRING);
					mapColumnInfoIn.put(n, cell.getStringCellValue());
					break;
				case 1:
					mapColumnInfoIn.put(n, cell.getStringCellValue());
					break;
				}
			}
			Map map = new HashMap();
			map.put("serial_code", mapColumnInfoIn.get(0));
			map.put("wz_code", mapColumnInfoIn.get(1));
			map.put("wz_name", mapColumnInfoIn.get(2));
			map.put("wz_prickie", mapColumnInfoIn.get(3));
			map.put("wz_price", mapColumnInfoIn.get(4));
			map.put("actual_price", mapColumnInfoIn.get(5));
			String sql = "select * from gms_device_bjgl where " + "wz_code='"
					+ mapColumnInfoIn.get(1) + "' and projectInfoNo='"
					+ projectInfoId + "' and bsflag=0";
			Map searchMap = this.jdbcDao.queryRecordBySQL(sql);
			if (null == searchMap) {
				map.put("stock_num", mapColumnInfoIn.get(6));
			} else {
				int old_stock_num = Integer.parseInt(searchMap.get("stock_num")
						.toString());
				int add_stock_num = Integer.parseInt(mapColumnInfoIn.get(1)
						.toString());
				Integer new_stock_num = old_stock_num + add_stock_num;
				map.put("stock_num", new_stock_num.toString());
				map.put("bj_id", searchMap.get("bj_id"));
			}

			dataList.add(map);
		}
		return dataList;

	}

	/**
	 * ��ѯ̨�˵Ļ�����Ϣ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevAccInfo(ISrvMsg reqDTO) throws Exception {
		String device_acc_id = reqDTO.getValue("deviceId");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer()
				.append("select t.*, ")
				.append("(select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, ")
				.append("(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,")
				.append("(select org_name from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,")
				.append("(select org_name from comm_org_information org where t.USAGE_ORG_ID=org.org_id) as usage_org_name_desc,")
				.append("(select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_id) as project_name_desc,")
				.append("d.coding_name as stat_desc from GMS_DEVICE_ACCOUNT_DUI t left join comm_coding_sort_detail d on t.account_stat=d.coding_code_id ")
				.append("where dev_acc_id='" + device_acc_id + "'");
		Map deviceaccMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (deviceaccMap != null) {
			responseMsg.setValue("deviceaccMap", deviceaccMap);
		}

		return responseMsg;
	}

	/**
	 * �����ƻ�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveByjhInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveByjhInfo");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map map = new HashMap();
		// ̨������
		String dev_acc_id = isrvmsg.getValue("dev_acc_id");
		String accountDetailSql = "select dev_name,self_num,dev_acc_id,project_info_id from gms_device_account_dui where dev_acc_id='"
				+ dev_acc_id + "'";
		//
		Map accountDetailMap = this.jdbcDao.queryRecordBySQL(accountDetailSql);
		if (null != accountDetailMap) {
			map.put("dev_acc_id", dev_acc_id);
			map.put("dev_name", accountDetailMap.get("dev_name"));
			map.put("self_num", accountDetailMap.get("self_num"));
			map.put("projectInfoNo", accountDetailMap.get("project_info_id"));
		}
		String updateByjhSql = "update GMS_DEVICE_ZY_BY c set  c.ISNEWBYMSG='1' where c.DEV_ACC_ID='"
				+ dev_acc_id
				+ "'  and   PROJECTINFONO='"
				+ user.getProjectInfoNo() + "'";
		jdbcDao.executeUpdate(updateByjhSql);
		// �´α���˳��
		String byjb = isrvmsg.getValue("byjb");
		String sgliSql = "select work_hour from gms_device_zy_project p where p.project_info_id='"
				+ user.getProjectInfoNo() + "'";

		//
		Map sgliMap = this.jdbcDao.queryRecordBySQL(sgliSql);
		// ��ȡ��ǰ��Ŀ�Ĺ���ʱ��
		String workHour = sgliMap.get("work_hour").toString();
		String xcbyjb = byjb.substring(0, 1);
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar c = Calendar.getInstance();
		// �볡�ۼƹ���Сʱ
		String runtime = isrvmsg.getValue("runtime");
		map.put("runtime", runtime);
		int nextHour = Integer.parseInt(runtime);
		// 250Сʱ
		if (xcbyjb.equals("B")) {
			int day = (int) Math.floor(250 / Integer.parseInt(workHour));
			c.add(Calendar.DAY_OF_MONTH, day);
			nextHour += 250;
		}
		// 1000Сʱ
		if (xcbyjb.equals("C")) {
			int day = (int) Math.floor(1000 / Integer.parseInt(workHour));
			c.add(Calendar.DAY_OF_MONTH, day);
			nextHour += 1000;
		}
		// 2000Сʱ
		if (xcbyjb.equals("D")) {
			int day = (int) Math.floor(2000 / Integer.parseInt(workHour));
			c.add(Calendar.DAY_OF_MONTH, day);
			nextHour += 2000;
		}
		String xcbysj = sf.format(c.getTime());
		map.put("BY_NEXTTIME", xcbysj);
		map.put("BYSX", byjb);
		map.put("byjb", xcbyjb);
		map.put("BY_NEXTHOURS", nextHour);
		map.put("bsflag", "0");
		map.put("create_date", new Date());
		map.put("creator", user.getUserId());
		map.put("submitor", user.getUserName());
		// ���±�����¼
		map.put("ISNEWBYMSG", "0");
		// �豸������ĿID
		String projectInfoNo = accountDetailMap.get("project_info_id")
				.toString();
		map.put("projectInfoNo", projectInfoNo);
		jdbcDao.saveOrUpdateEntity(map, "GMS_DEVICE_ZY_BY");
		responseDTO.setValue("data", "0");
		return responseDTO;
	}

	/**
	 * �ɿ���Դ-�±����ѯ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getzyMonthReport(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String queryProjectSql = " select * from  ( select * from GMS_DEVICE_ZY_M_REPORT m where m.project_info_id='"
				+ user.getProjectInfoNo()
				+ "' order by m.fill_date desc ) where rownum <2";

		Map deviceProjectMap = jdbcDao.queryRecordBySQL(queryProjectSql
				.toString());
		String querysgllSql = "   select l.sgli_id, dui.dev_acc_id, dui.self_num,  dui.dev_model,  l.control_box, l.dgps_type,l.work_m_hour,l.work_hour,l.create_date,l.bak  from gms_device_account_dui dui  left join GMS_DEVICE_ZY_SGLI l on l.dev_acc_id = dui.dev_acc_id where dui.dev_type like 'S062301%'";
		querysgllSql += " and dui.project_info_id = '"
				+ user.getProjectInfoNo()
				+ "'  and l.create_date is not null     and l.m_id in (select tt.m_id from (select *  from GMS_DEVICE_ZY_M_REPORT m  where m.project_info_id = '"
				+ user.getProjectInfoNo() + "' ";
		querysgllSql += "  order by m.fill_date desc )tt where rownum<2) ";
		querysgllSql += " union all select l.sgli_id, dui.dev_acc_id, dui.self_num,  dui.dev_model,  l.control_box, l.dgps_type,l.work_m_hour,l.work_hour,l.create_date,l.bak  from gms_device_account_dui dui  left join GMS_DEVICE_ZY_SGLI l on l.dev_acc_id = dui.dev_acc_id where dui.dev_type like 'S062301%'";
		querysgllSql += " and dui.project_info_id = '"
				+ user.getProjectInfoNo() + "'  and l.create_date is  null ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		if (deviceProjectMap != null) {
			responseDTO.setValue("projectMap", deviceProjectMap);
		}
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * �ɿ���Դ-ʩ��������Ϣ��ѯ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZysglvInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String queryProjectSql = "select * from GMS_DEVICE_ZY_PROJECT p  where p.PROJECT_INFO_ID='"
				+ projectInfoNo + "'";
		Map deviceProjectMap = jdbcDao.queryRecordBySQL(queryProjectSql
				.toString());
		String querysgllSql = "   select * from (  select l.sgli_id, dui.dev_acc_id, dui.self_num,  dui.dev_model,  l.control_box, l.dgps_type, l.work_hour,  l.work_m_hour,l.create_date  from gms_device_account_dui dui  left join GMS_DEVICE_ZY_SGLI l on l.dev_acc_id = dui.dev_acc_id where dui.dev_type like 'S062301%'";
		querysgllSql += " and dui.project_info_id = '"
				+ user.getProjectInfoNo()
				+ "'  and l.create_date is not null  order by l.create_date desc ) where rownum<2   union all ";
		querysgllSql += " select l.sgli_id, dui.dev_acc_id, dui.self_num,   dui.dev_model,   l.control_box,  l.dgps_type,  l.work_hour, l.work_m_hour,l.create_date  from gms_device_account_dui dui left join GMS_DEVICE_ZY_SGLI l on l.dev_acc_id = dui.dev_acc_id  where dui.dev_type like 'S062301%' and l.create_date is null and dui.project_info_id = '"
				+ user.getProjectInfoNo() + "'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		if (deviceProjectMap != null) {
			responseDTO.setValue("projectMap", deviceProjectMap);
		}
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * NEWMETHOD ����ʩ��������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSgllInfo(ISrvMsg msg) throws Exception {
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// 1.������������-�������
		String local_temp_low = msg.getValue("local_temp_low");
		// �������
		String local_temp_height = msg.getValue("local_temp_height");
		// 2.�ر�����
		String surface = msg.getValue("surface");
		// ����ʱ��
		String work_hour = msg.getValue("work_hour");
		// ��Ŀ��
		String projecter = msg.getValue("projecter");
		String construction_method = msg.getValue("construction_method");
		String construction_params = msg.getValue("construction_params");
		String import_info = msg.getValue("import_info");
		String country = msg.getValue("country");
		String project_address = msg.getValue("project_address");
		UserToken user = msg.getUserToken();
		// ��Ŀ���
		String projectInfoNo = user.getProjectInfoNo();
		// ������Ŀ��Ų�ѯ��Ŀ�Ƿ���������Ϣ
		String ProjectSql = "select * from gms_device_zy_project  p where p.project_info_id='"
				+ projectInfoNo + "'";
		Map deviceProjectMap = jdbcDao.queryRecordBySQL(ProjectSql.toString());
		Map<String, Object> dataProjectMap = new HashMap<String, Object>();
		// ���²���
		if (deviceProjectMap != null) {
			dataProjectMap
					.put("project_id", deviceProjectMap.get("project_id"));
			dataProjectMap.put("work_hour", work_hour);
			dataProjectMap.put("local_temp_low", local_temp_low);
			dataProjectMap.put("local_temp_height", local_temp_height);
			dataProjectMap.put("surface", surface);
			dataProjectMap.put("projecter", projecter);
			dataProjectMap.put("project_info_id", projectInfoNo);
			dataProjectMap.put("construction_method", construction_method);
			dataProjectMap.put("construction_paramete", construction_params);
			dataProjectMap.put("country", country);
			// dataProjectMap.put("import_info", import_info);
			dataProjectMap.put("project_address", project_address);

			String id = deviceProjectMap.get("project_id").toString();
			String updateSql = "update GMS_DEVICE_ZY_PROJECT set work_hour='"
					+ work_hour + "'," + "local_temp_low='" + local_temp_low
					+ "'," + "local_temp_height='" + local_temp_height + "',"
					+ "surface='" + surface + "'," + "projecter='" + projecter
					+ "'," + "PROJECT_INFO_ID='" + projectInfoNo + "',"
					+ "construction_method='" + construction_method + "',"
					+ "construction_paramete='" + construction_params + "',"
					+ "country='" + country + "'," + "project_address='"
					+ project_address + "'" + "where  project_id='" + id + "'";
			jdbcDao.executeUpdate(updateSql);
		}
		// ������Ŀ������Ϣ
		else {
			// dataProjectMap.put("work_hour", work_hour);
			// dataProjectMap.put("local_temp_low", local_temp_low);
			// dataProjectMap.put("local_temp_height", local_temp_height);
			// dataProjectMap.put("surface", surface);
			// dataProjectMap.put("projecter", projecter);
			// dataProjectMap.put("PROJECT_INFO_ID", projectInfoNo);
			// dataProjectMap.put("construction_method", construction_method);
			// dataProjectMap.put("construction_paramete", construction_params);
			// dataProjectMap.put("country", country);
			// dataProjectMap.put("project_address", project_address);
			String project_id = UUID.randomUUID().toString()
					.replaceAll("-", "");
			String insertSQL = " INSERT INTO GMS_DEVICE_ZY_PROJECT (PROJECT_ID,LOCAL_TEMP_LOW,SURFACE,WORK_HOUR,PROJECTER,PROJECT_INFO_ID,LOCAL_TEMP_HEIGHT,CONSTRUCTION_METHOD,CONSTRUCTION_PARAMETE,PROJECT_ADDRESS,COUNTRY) VALUES(";
			insertSQL += "'" + project_id + "',";
			insertSQL += "'" + local_temp_low + "',";
			insertSQL += "'" + surface + "',";
			insertSQL += "'" + work_hour + "',";
			insertSQL += "'" + projecter + "',";
			insertSQL += "'" + projectInfoNo + "',";
			insertSQL += "'" + local_temp_height + "',";
			insertSQL += "'" + construction_method + "',";
			insertSQL += "'" + construction_params + "',";
			insertSQL += "'" + project_address + "',";
			insertSQL += "'" + country + "')";
			pureJdbcDao.executeUpdate(insertSQL);

			// pureJdbcDao.saveOrUpdateEntity(dataProjectMap,
			// "GMS_DEVICE_ZY_PROJECT");
		}

		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("info", "���³ɹ�");
		return responseDTO;
	}

	/**
	 * NEWMETHOD ����ɿ���Դ�±�����Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMonthInfo(ISrvMsg msg) throws Exception {
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");

		String construction_method = msg.getValue("construction_method");
		String construction_parameter = msg.getValue("construction_parameter");
		String import_info = msg.getValue("import_info");
		String fill_month = msg.getValue("fill_month");
		String project_address = msg.getValue("project_address");
		String combination = msg.getValue("combination");
		String ilo_info = msg.getValue("ilo_info");
		String person_info = msg.getValue("person_info");
		String local_temp_height = msg.getValue("local_temp_height");
		String local_temp_low = msg.getValue("local_temp_low");
		UserToken user = msg.getUserToken();

		String id = "";
		// ��Ŀ���
		String projectInfoNo = user.getProjectInfoNo();
		// ������Ŀ��Ų�ѯ��Ŀ�Ƿ���������Ϣ
		String ProjectSql = "select * from GMS_DEVICE_ZY_M_REPORT  p where p.project_info_id='"
				+ projectInfoNo + "' and fill_month='" + fill_month + "'";
		Map deviceProjectMap = jdbcDao.queryRecordBySQL(ProjectSql.toString());
		Map<String, Object> dataProjectMap = new HashMap<String, Object>();
		// ���²���
		if (deviceProjectMap != null) {
			id = deviceProjectMap.get("m_id").toString();
			dataProjectMap.put("m_id", deviceProjectMap.get("m_id"));
			dataProjectMap.put("construction_method", construction_method);
			dataProjectMap
					.put("construction_parameter", construction_parameter);
			dataProjectMap.put("import_info", import_info);
			dataProjectMap.put("fill_month", fill_month);
			dataProjectMap.put("project_address", project_address);
			dataProjectMap.put("combination", combination);
			dataProjectMap.put("ilo_info", ilo_info);
			dataProjectMap.put("person_info", person_info);
			dataProjectMap.put("import_info", import_info);
			dataProjectMap.put("fill_date", currentdate);
			dataProjectMap.put("PROJECT_INFO_ID", projectInfoNo);
			dataProjectMap.put("fill_name", user.getUserName());
			dataProjectMap.put("local_temp_height", local_temp_height);
			dataProjectMap.put("local_temp_low", local_temp_low);
			jdbcDao.saveOrUpdateEntity(dataProjectMap, "GMS_DEVICE_ZY_M_REPORT");
		}
		// ������Ŀ������Ϣ
		else {
			dataProjectMap.put("construction_method", construction_method);
			dataProjectMap
					.put("construction_parameter", construction_parameter);
			dataProjectMap.put("import_info", import_info);
			dataProjectMap.put("fill_month", fill_month);
			dataProjectMap.put("project_address", project_address);
			dataProjectMap.put("combination", combination);
			dataProjectMap.put("ilo_info", ilo_info);
			dataProjectMap.put("person_info", person_info);
			dataProjectMap.put("import_info", import_info);
			dataProjectMap.put("fill_date", currentdate);
			dataProjectMap.put("PROJECT_INFO_ID", projectInfoNo);
			dataProjectMap.put("fill_name", user.getUserName());
			dataProjectMap.put("local_temp_height", local_temp_height);
			dataProjectMap.put("local_temp_low", local_temp_low);
			Serializable ids = jdbcDao.saveOrUpdateEntity(dataProjectMap,
					"GMS_DEVICE_ZY_M_REPORT");
			id = ids.toString();
		}

		// ѡ�е�����
		int count = Integer.parseInt(msg.getValue("count"));
		// �洢
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			String control_box = msg.getValue("control_box" + keyid);
			String dgps_type = msg.getValue("dgps_type" + keyid);
			String work_hour1 = msg.getValue("work_hour" + keyid);
			String work_m_hour = msg.getValue("work_m_hour" + keyid);
			String bak = msg.getValue("bak" + keyid);
			String sgli_id = msg.getValue("sgli_id" + keyid);
			String performance_desc = msg.getValue("performance_desc" + keyid);
			// �豸ID
			String dev_acc_id = msg.getValue("dev_acc_id" + keyid);
			String querySql = "select * from gms_device_zy_sgli l where l.m_id='"
					+ id + "' and l.dev_acc_id='" + dev_acc_id + "'";
			Map devicesgliMap = jdbcDao.queryRecordBySQL(querySql.toString());
			if (devicesgliMap != null) {
				// ɾ����¼
				String querysgllSql = "delete from gms_device_zy_sgli l where l.m_id='"
						+ id + "' and l.dev_acc_id='" + dev_acc_id + "'";
				jdbcDao.executeUpdate(querysgllSql);
			}
			dataMap.put("sgli_id", sgli_id);
			dataMap.put("bak", bak);
			dataMap.put("control_box", control_box);
			dataMap.put("dgps_type", dgps_type);
			dataMap.put("work_hour", work_hour1);
			dataMap.put("work_m_hour", work_m_hour);
			dataMap.put("dev_acc_id", dev_acc_id);
			dataMap.put("bsflag", "0");
			dataMap.put("PROJECT_INFO_ID", projectInfoNo);
			dataMap.put("CREATE_DATE", currentdate);
			dataMap.put("CREATOR_ID", user.getUserId());
			dataMap.put("performance_desc", performance_desc);
			dataMap.put("m_id", id);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_zy_sgli");

		}

		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("info", "���³ɹ�");
		return responseDTO;
	}

	/**
	 * ��ѯ�ɿ���Դ��Ϣ-����Ŀ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getdeviceZyInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_id = msg.getValue("wz_id");
		String querysgllSql = "select  dui.self_num, dui.dev_acc_id   from gms_device_account_dui  dui   where   dui.dev_acc_id in("
				+ wz_id + ") ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ��ѯ�ɿ���Դ��Ϣ-����Ŀ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getdeviceZyInfos(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_id = msg.getValue("wz_id");
		String querysgllSql = "select  dui.self_num, dui.dev_acc_id   from gms_device_account  dui   where   dui.dev_acc_id in("
				+ wz_id + ") ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * NEWMETHOD �����ܳɼ�ά�޼�¼
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveZcjwxInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();

		String SubOrgId = user.getSubOrgIDofAffordOrg();
		String orgId = user.getOrgId();
		// ѡ�е�����
		int count = Integer.parseInt(msg.getValue("count"));
		// �洢
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			// �ܳɼ�ά��ID
			String zcjwx_id = msg.getValue("zcjwx_id" + keyid);
			// ά������
			String wx_date = msg.getValue("wx_date" + keyid);
			// �豸ID
			String dev_acc_id = msg.getValue("dev_acc_id" + keyid);
			// �ܳɼ����Ƽ��ͺ�
			String zcj_name = msg.getValue("zcj_name" + keyid);
			// ���к�
			String sequence = msg.getValue("sequence" + keyid);
			// �ۼƹ���Сʱ
			String work_hour = msg.getValue("work_hour" + keyid);
			// ά�޼���
			String wx_level = msg.getValue("wx_level" + keyid);
			// ά����Ҫ����
			String wx_content = msg.getValue("wx_content" + keyid);
			String performance_desc = msg.getValue("performance_desc" + keyid);
			String worker = msg.getValue("worker" + keyid);
			String worker_unit = msg.getValue("worker_unit" + keyid);
			String accepter = msg.getValue("accepter" + keyid);
			String bak = msg.getValue("bak" + keyid);
			// �ͺ�
			String zcj_model = msg.getValue("zcj_model" + keyid);
			if (zcjwx_id != "" && zcjwx_id != "undefined") {
				dataMap.put("zcjwx_id", zcjwx_id);
				dataMap.put("wx_date", wx_date);
				dataMap.put("sequence", sequence);
				dataMap.put("work_hour", work_hour);
				dataMap.put("zcj_name", zcj_name);
				dataMap.put("zcj_model", zcj_model);
				dataMap.put("wx_level", wx_level);
				dataMap.put("wx_content", wx_content);
				dataMap.put("performance_desc", performance_desc);
				dataMap.put("worker", worker);
				dataMap.put("worker_unit", worker_unit);
				dataMap.put("accepter", accepter);
				dataMap.put("bak", bak);
				dataMap.put("dev_acc_id", dev_acc_id);
				dataMap.put("bsflag", "0");
				dataMap.put("ORG_SUBJECTION_ID", SubOrgId);
				dataMap.put("create_date", new Date());
				dataMap.put("ORG_ID", orgId);
				jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_ZCJWX");
			} else {
				dataMap.put("wx_date", wx_date);
				dataMap.put("sequence", sequence);
				dataMap.put("work_hour", work_hour);
				dataMap.put("zcj_name", zcj_name);
				dataMap.put("zcj_model", zcj_model);
				dataMap.put("wx_level", wx_level);
				dataMap.put("wx_content", wx_content);
				dataMap.put("performance_desc", performance_desc);
				dataMap.put("worker", worker);
				dataMap.put("worker_unit", worker_unit);
				dataMap.put("accepter", accepter);
				dataMap.put("bak", bak);
				dataMap.put("dev_acc_id", dev_acc_id);
				dataMap.put("bsflag", "0");
				dataMap.put("ORG_SUBJECTION_ID", SubOrgId);
				dataMap.put("ORG_ID", orgId);
				dataMap.put("CREATE_DATE", new Date());
				jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_ZCJWX");
			}

		}
		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * ��ѯ�ܳɼ�ά�޼�¼
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getzcjwxInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wx_id = msg.getValue("wx_id");
		String querysgllSql = "select  l.zcjwx_id,l.wx_date,(select  t.coding_name  from comm_coding_sort_detail  t  where t.coding_code_id=l.zcj_name) as zcj_name ,l.sequence,l.work_hour,  d.coding_name as wx_level,l.performance_desc,l.worker, l.wx_content, l.worker_unit, l.accepter,l.bak, dui.self_num, dui.dev_acc_id   from gms_device_zy_zcjwx l    left join comm_coding_sort_detail d on d.coding_code_id=l.wx_level  left join gms_device_account dui on dui.dev_acc_id = l.dev_acc_id where   l.zcjwx_id ='"
				+ wx_id + "' ";
		Map map = jdbcDao.queryRecordBySQL(querysgllSql);
		responseDTO.setValue("deviceaccMap", map);
		return responseDTO;
	}

	/**
	 * ɾ���ܳɼ�ά�޼�¼
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deletezcjwxInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wx_id = msg.getValue("wx_ids");
		String querysgllSql = "update gms_device_zy_zcjwx z set bsflag='1'  where z.zcjwx_id in("
				+ wx_id + ") ";
		jdbcDao.executeUpdate(querysgllSql);
		return responseDTO;
	}

	/**
	 * ��ѯ�ܳɼ�ά�޼�¼
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getzcjwxInfos(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wx_id = msg.getValue("wx_ids");
		String querysgllSql = "select l.zcj_model, l.zcjwx_id,l.wx_date,l.zcj_name,l.sequence,l.work_hour,l.wx_level,l.performance_desc,l.worker,l.wx_content,l.worker_unit,l.accepter,l.bak, dui.self_num, dui.dev_acc_id   from gms_device_zy_zcjwx l  left join gms_device_account dui on dui.dev_acc_id = l.dev_acc_id where   l.zcjwx_id  in ('"
				+ wx_id + "') ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * NEWMETHOD ���汣��ά�޼�¼--��Դ--����Ŀ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveBywxInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// ��Ŀ���
		String projectInfoNo = user.getProjectInfoNo();
		// ѡ�е�����
		int count = Integer.parseInt(msg.getValue("count"));
		// �洢
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			String bywx_id = msg.getValue("bywx_id" + keyid);
			String bywx_type = msg.getValue("bywx_type" + keyid);
			String zcj_type = msg.getValue("zcj_type" + keyid);
			String bywx_date = msg.getValue("bywx_date" + keyid);
			String work_hours = msg.getValue("work_hours" + keyid);
			String falut_desc = msg.getValue("falut_desc" + keyid);
			String falut_case = msg.getValue("falut_case" + keyid);
			String falut_reason = msg.getValue("falut_reason" + keyid);
			String usemat_id = msg.getValue("usemat_id" + keyid);
			String maintenance_level = msg
					.getValue("maintenance_level" + keyid) == null ? "��" : msg
					.getValue("maintenance_level" + keyid);
			String maintenance_desc = msg.getValue("maintenance_desc" + keyid);
			String performance_desc = msg.getValue("performance_desc" + keyid);
			String legacy = msg.getValue("legacy" + keyid);
			String repair_unit = msg.getValue("repair_unit" + keyid);
			String repair_men = msg.getValue("repair_men" + keyid);
			String dev_acc_id = msg.getValue("dev_acc_id" + keyid);
			String self_num = msg.getValue("self_num" + keyid);
			String bak = msg.getValue("bak" + keyid);
			if (bywx_id != "" && bywx_id != "undefined") {
				dataMap.put("bywx_id", bywx_id);
				dataMap.put("bywx_date", bywx_date);
				dataMap.put("bywx_type", bywx_type);
				dataMap.put("zcj_type", zcj_type);
				dataMap.put("work_hours", work_hours);
				dataMap.put("falut_desc", falut_desc);
				dataMap.put("falut_reason", falut_reason);
				dataMap.put("falut_case", falut_case);
				dataMap.put("maintenance_level", maintenance_level);
				dataMap.put("maintenance_desc", maintenance_desc);
				dataMap.put("performance_desc", performance_desc);
				dataMap.put("legacy", legacy);
				dataMap.put("repair_unit", repair_unit);
				dataMap.put("repair_men", repair_men);
				dataMap.put("usemat_id", usemat_id);
				dataMap.put("creator", user.getUserId());
				dataMap.put("create_date", new Date());
				dataMap.put("bak", bak);
				dataMap.put("bsflag", "0");
				dataMap.put("PROJECT_INFO_ID", projectInfoNo);
				dataMap.put("org_id", user.getOrgId());
				dataMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
				dataMap.put("dev_acc_id", dev_acc_id);
				jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_BYWX");
			} else {
				dataMap.put("modifier", user.getUserId());
				dataMap.put("modifi_date", new Date());
				dataMap.put("bywx_type", bywx_type);
				dataMap.put("zcj_type", zcj_type);
				dataMap.put("bywx_date", bywx_date);
				dataMap.put("work_hours", work_hours);
				dataMap.put("falut_desc", falut_desc);
				dataMap.put("falut_case", falut_case);
				dataMap.put("falut_reason", falut_reason);
				dataMap.put("maintenance_level", maintenance_level);
				dataMap.put("maintenance_desc", maintenance_desc);
				dataMap.put("performance_desc", performance_desc);
				dataMap.put("legacy", legacy);
				dataMap.put("repair_unit", repair_unit);
				dataMap.put("repair_men", repair_men);
				dataMap.put("bak", bak);
				dataMap.put("bsflag", "0");
				dataMap.put("bak", bak);
				dataMap.put("usemat_id", usemat_id);
				dataMap.put("PROJECT_INFO_ID", projectInfoNo);
				dataMap.put("org_id", user.getOrgId());
				dataMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
				dataMap.put("dev_acc_id", dev_acc_id);
				jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_BYWX");
			}
			if (!"��".equals(maintenance_level)) {
				String sgliSql = "select work_hour from gms_device_zy_project p where p.project_info_id='"
						+ user.getProjectInfoNo() + "'";
				Map sgliMap = this.jdbcDao.queryRecordBySQL(sgliSql);
				String queryBySql = "select zy.bysx,zy.dev_acc_id,zy.dev_name,zy.self_num ,zy.runtime from gms_device_zy_by zy  WHERE  zy.isnewbymsg='0' and zy.dev_acc_id='"
						+ dev_acc_id + "' ";
				Map map = jdbcDao.queryRecordBySQL(queryBySql);
				Map newMap = new HashMap();
				if (null != map) {
					newMap.put("dev_acc_id", map.get("dev_acc_id").toString());
					newMap.put("self_num", map.get("self_num").toString());
				} else {
					newMap.put("dev_acc_id", dev_acc_id);
					newMap.put("self_num", self_num);
				}

				// ��ȡ��ǰ��Ŀ�Ĺ���ʱ��
				if (sgliMap != null && map != null) {
					String workHour = sgliMap.get("work_hour").toString();
					String bysx = map.get("bysx").toString();

					String xcbyjb = bysx.substring(0, 1);
					bysx = bysx.substring(1, bysx.length());
					String bysxNew = "";
					String updateByjhSql = "update GMS_DEVICE_ZY_BY c set  c.ISNEWBYMSG='1' where c.DEV_ACC_ID='"
							+ dev_acc_id + "'";
					jdbcDao.executeUpdate(updateByjhSql);
					// ��ȡ�´α�������
					if (maintenance_level.equals("B") && xcbyjb.equals("B")) {
						bysxNew = bysx + "B";

					}
					if (maintenance_level.equals("C") && xcbyjb.equals("C")) {
						bysxNew = "BBBD";
					}
					if (maintenance_level.equals("D") && xcbyjb.equals("D")) {
						bysxNew = "BBBC";
					}
					if (maintenance_level.equals("C") && xcbyjb.equals("B")) {
						bysxNew = "BBBD";
					}
					if (maintenance_level.equals("D") && xcbyjb.equals("B")) {
						bysxNew = "BBBC";
					}
					String xcbyjbNew = bysxNew.substring(0, 1);
					int nextHour = Integer.parseInt(work_hours);
					SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
					Calendar c = Calendar.getInstance();
					// 250Сʱ
					if (xcbyjbNew.equals("B")) {
						int day = (int) Math.floor(250 / Integer
								.parseInt(workHour));
						c.add(Calendar.DAY_OF_MONTH, day);
						nextHour += 250;
					}
					// 1000Сʱ
					if (xcbyjbNew.equals("C")) {
						int day = (int) Math.floor(1000 / Integer
								.parseInt(workHour));
						c.add(Calendar.DAY_OF_MONTH, day);
						nextHour += 1000;
					}
					// 2000Сʱ
					if (xcbyjbNew.equals("D")) {
						int day = (int) Math.floor(2000 / Integer
								.parseInt(workHour));
						c.add(Calendar.DAY_OF_MONTH, day);
						nextHour += 2000;
					}

					newMap.put("BY_NEXTTIME", sf.format(c.getTime()));
					newMap.put("BYSX", bysxNew);
					newMap.put("byjb", xcbyjb);
					newMap.put("BY_NEXTHOURS", nextHour);
					newMap.put("bsflag", "0");
					// ���±�����¼
					newMap.put("ISNEWBYMSG", "0");
					newMap.put("projectInfoNo", user.getProjectInfoNo());
					jdbcDao.saveOrUpdateEntity(newMap, "GMS_DEVICE_ZY_BY");

				}

			}

		}
		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * NEWMETHOD ���汣��ά�޼�¼--��Դ--����Ŀ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveBywxInfos(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// ��Ŀ���
		String projectInfoNo = user.getProjectInfoNo();
		// ѡ�е�����
		int count = Integer.parseInt(msg.getValue("count"));
		// �洢
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			String bywx_id = msg.getValue("bywx_id" + keyid);
			String bywx_date = msg.getValue("bywx_date" + keyid);
			String work_hours = msg.getValue("work_hours" + keyid);
			String falut_desc = msg.getValue("falut_desc" + keyid);
			String falut_case = msg.getValue("falut_case" + keyid);
			String falut_reason = msg.getValue("falut_reason" + keyid);
			String bywx_type = msg.getValue("bywx_type" + keyid);
			String zcj_type = msg.getValue("zcj_type" + keyid);
			String usemat_id = msg.getValue("usemat_id" + keyid);
			String maintenance_level = msg
					.getValue("maintenance_level" + keyid) == null ? "��" : msg
					.getValue("maintenance_level" + keyid);
			String maintenance_desc = msg.getValue("maintenance_desc" + keyid);
			String performance_desc = msg.getValue("performance_desc" + keyid);
			String legacy = msg.getValue("legacy" + keyid);
			String repair_unit = msg.getValue("repair_unit" + keyid);
			String repair_men = msg.getValue("repair_men" + keyid);
			String dev_acc_id = msg.getValue("dev_acc_id" + keyid);
			String bak = msg.getValue("bak" + keyid);
			if (bywx_id != "" && bywx_id != "undefined") {
				dataMap.put("bywx_id", bywx_id);
				dataMap.put("bywx_date", bywx_date);
				dataMap.put("bywx_type", bywx_type);
				dataMap.put("zcj_type", zcj_type);
				dataMap.put("work_hours", work_hours);
				dataMap.put("falut_desc", falut_desc);
				dataMap.put("falut_case", falut_case);
				dataMap.put("falut_reason", falut_reason);
				dataMap.put("maintenance_level", maintenance_level);
				dataMap.put("maintenance_desc", maintenance_desc);
				dataMap.put("performance_desc", performance_desc);
				dataMap.put("creator", user.getUserId());
				dataMap.put("create_date", new Date());
				dataMap.put("legacy", legacy);
				dataMap.put("repair_unit", repair_unit);
				dataMap.put("repair_men", repair_men);
				dataMap.put("usemat_id", usemat_id);
				dataMap.put("bak", bak);
				dataMap.put("bsflag", "0");
				dataMap.put("dev_acc_id", dev_acc_id);
				dataMap.put("org_id", user.getOrgId());
				dataMap.put("org_subjection_id", user.getOrgSubjectionId());
				jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_BYWX");
			} else {
				dataMap.put("modifier", user.getUserId());
				dataMap.put("modifi_date", new Date());
				dataMap.put("bywx_date", bywx_date);
				dataMap.put("work_hours", work_hours);
				dataMap.put("bywx_type", bywx_type);
				dataMap.put("zcj_type", zcj_type);
				dataMap.put("falut_desc", falut_desc);
				dataMap.put("falut_case", falut_case);
				dataMap.put("falut_reason", falut_reason);
				dataMap.put("maintenance_level", maintenance_level);
				dataMap.put("maintenance_desc", maintenance_desc);
				dataMap.put("performance_desc", performance_desc);
				dataMap.put("legacy", legacy);
				dataMap.put("repair_unit", repair_unit);
				dataMap.put("repair_men", repair_men);
				dataMap.put("bak", bak);
				dataMap.put("bsflag", "0");
				dataMap.put("bak", bak);
				dataMap.put("usemat_id", usemat_id);
				dataMap.put("dev_acc_id", dev_acc_id);
				dataMap.put("org_id", user.getOrgId());
				dataMap.put("org_subjection_id", user.getOrgSubjectionId());
				jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_BYWX");
			}

		}
		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * ��ѯ����ά�޼�¼-����Ŀ-��Դ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevBywxInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wx_id = msg.getValue("wx_id");
		String querysgllSql = "select  (case when l.bywx_type='0' then '����' when l.bywx_type='1' then 'ά��' end) as bywx_type, (case when d.coding_name is null then '��' when d.coding_name is not null then d.coding_name end)  as zcj_type,l.bywx_id,l.bywx_date,l.work_hours,l.falut_desc,l.falut_case,l.maintenance_level,l.maintenance_desc,(case  when l.performance_desc = '0' then    '����'    when l.performance_desc = '1' then '����'  when l.performance_desc = '2' then '����' end) as performance_desc,l.falut_reason,l.legacy,l.repair_unit,l.repair_men,l.bak, dui.self_num, dui.dev_acc_id,dui.dev_model,dui.dev_name  from gms_device_zy_bywx l  left join gms_device_account_dui dui on dui.dev_acc_id = l.dev_acc_id  left join comm_coding_sort_detail d on d.coding_code_id=l.zcj_type  where l.bywx_id='"
				+ wx_id + "'";
		Map map = jdbcDao.queryRecordBySQL(querysgllSql);
		responseDTO.setValue("deviceaccMap", map);
		return responseDTO;
	}

	/**
	 * ��ѯ����ά�޼�¼-����Ŀ-��Դ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevBywxInfos(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String wx_id = msg.getValue("wx_id");
		String querysgllSql = "select  (case when l.bywx_type='0' then '����' when l.bywx_type='1' then 'ά��' end) as bywx_type, (case when d.coding_name is null then '��' when d.coding_name is not null then d.coding_name end)  as zcj_type, l.bywx_id,l.bywx_date,l.work_hours,l.falut_desc,l.falut_case,l.maintenance_level,l.maintenance_desc,(case  when l.performance_desc = '0' then    '����'    when l.performance_desc = '1' then '����'  when l.performance_desc = '2' then '����' end) as performance_desc,l.falut_reason,l.legacy,l.repair_unit,l.repair_men,l.bak, dui.self_num, dui.dev_acc_id,dui.dev_model,dui.dev_name  from gms_device_zy_bywx l  left join gms_device_account dui on dui.dev_acc_id = l.dev_acc_id  left join comm_coding_sort_detail d on d.coding_code_id=l.zcj_type  where l.bywx_id='"
				+ wx_id + "'";
		Map map = jdbcDao.queryRecordBySQL(querysgllSql);
		responseDTO.setValue("deviceaccMap", map);
		return responseDTO;
	}

	/**
	 * ��ѯά�ޱ����ƻ���¼����Ŀ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getwxbyInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wx_id = msg.getValue("wx_ids");
		String querysgllSql = "select  l.bywx_type,l.zcj_type, l.usemat_id, l.bywx_id,l.bywx_date,l.work_hours,l.falut_desc,l.falut_reason,l.falut_case,l.maintenance_level,l.maintenance_desc,l.performance_desc,l.legacy,l.repair_unit,l.repair_men,l.bak, dui.self_num, dui.dev_acc_id,dui.dev_model,dui.dev_name  from gms_device_zy_bywx l  left join gms_device_account_dui dui on dui.dev_acc_id = l.dev_acc_id  where l.bywx_id='"
				+ wx_id + "'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ��ѯά�ޱ����ƻ���¼����Ŀ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getwxbyInfos(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wx_id = msg.getValue("wx_ids");
		String querysgllSql = "select  l.bywx_type,l.zcj_type, l.usemat_id, l.bywx_id,l.bywx_date,l.work_hours,l.falut_desc,l.falut_reason,l.falut_case,l.maintenance_level,l.maintenance_desc,l.performance_desc,l.legacy,l.repair_unit,l.repair_men,l.bak, dui.self_num, dui.dev_acc_id,dui.dev_model,dui.dev_name  from gms_device_zy_bywx l  left join gms_device_account dui on dui.dev_acc_id = l.dev_acc_id  where l.bywx_id='"
				+ wx_id + "'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ɾ������ά�޼�¼
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deletebywxInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wx_id = msg.getValue("wx_ids");
		String querysgllSql = "update gms_device_zy_bywx z set bsflag='1'  where z.bywx_id in("
				+ wx_id + ") ";
		jdbcDao.executeUpdate(querysgllSql);
		return responseDTO;
	}

	/**
	 * ��Դ-��ѯ����Ŀ���õ�����
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZymatInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wx_id = msg.getValue("wx_ids");
		String querysgllSql = "select l.wz_code,l.wz_name,l.wz_prickie,l.actual_price,l.stock_num,t.use_num,t.coding_code_id,t.wxbymat_id,t.usemat_id from gms_device_bjgl l left join gms_device_zy_wxbymat t on t.wz_id=l.wz_code where l.projectinfono='"
				+ projectInfoNo + "'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * NEWMETHOD ����������������--����Ŀ-�ɿ���Դ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveBywxMatInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// ��Ŀ���
		String projectInfoNo = user.getProjectInfoNo();
		// ѡ�е�����
		int count = Integer.parseInt(msg.getValue("count"));
		// �洢����
		String info = "";
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			String wxbymat_id = msg.getValue("wxbymat_id" + keyid);
			String wz_code = msg.getValue("wz_code" + keyid);
			String use_num = msg.getValue("use_num" + keyid);
			String coding_code_id = msg.getValue("coding_code_id" + keyid);
			String usemat_id = msg.getValue("usemat_id" + keyid);
			if (wxbymat_id != "" && wxbymat_id != "undefined") {
				dataMap.put("wxbymat_id", wxbymat_id);
				dataMap.put("usemat_id", usemat_id);
				dataMap.put("wz_id", wz_code);
				dataMap.put("use_num", use_num);
				dataMap.put("coding_code_id", coding_code_id);
				dataMap.put("bsflag", "0");
				jdbcDao.saveOrUpdateEntity(dataMap, "Gms_Device_Zy_Wxbymat");
			} else {
				dataMap.put("wz_id", wz_code);
				dataMap.put("use_num", use_num);
				dataMap.put("usemat_id", usemat_id);
				dataMap.put("coding_code_id", coding_code_id);
				dataMap.put("bsflag", "0");
				Serializable id = jdbcDao.saveOrUpdateEntity(dataMap,
						"Gms_Device_Zy_Wxbymat");
				info = id.toString();
			}
		}
		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("info", info);
		return responseDTO;
	}

	/**
	 * ����̨�˵���������ϸ��Ϣ��ѯ���ɿ���Դ���ʣ�����Ŀ--------------cc
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatRep(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String sql = "select i.*, c.code_name, tt.stock_num,tt.actual_price,tt.wz_sequence,tt.recyclemat_info from (select  t.wz_id,t.wz_sequence, t.recyclemat_info,t.stock_num,t.actual_price from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'   and t.project_info_id='"
				+ user.getProjectInfoNo()
				+ "'  ) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on tt.wz_id=i.wz_id  where tt.recyclemat_info='"
				+ id + "' order by i.coding_code_id asc, i.wz_id asc";
		Map map = jdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * ����̨�˵���������ϸ��Ϣ��ѯ���ɿ���Դ���ʣ�����Ŀ--------------cc
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatReps(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String sql = "select i.*, c.code_name, tt.stock_num,tt.actual_price,tt.wz_sequence,tt.recyclemat_info from (select  t.wz_id,t.wz_sequence,  t.recyclemat_info,t.stock_num,t.actual_price from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'   and t.project_info_id is null and t.org_subjection_id like '"
				+ user.getOrgSubjectionId()
				+ "%'  ) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on tt.wz_id=i.wz_id  where tt.recyclemat_info='"
				+ id + "' order by i.coding_code_id asc, i.wz_id asc";
		Map map = jdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * �ɿ���Դ����excel�������ݿ�
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveExcelRepMat(ISrvMsg reqDTO) throws Exception {
		JdbcTemplate jdbcTemplate = this.jdbcDao.getJdbcTemplate();

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		String errorMessage = null;
		/**
		 * ��ȡexcel�е�����
		 */
		List<WSFile> files = mqMsg.getFiles();
		List<Map> columnList = new ArrayList<Map>();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil
						.getRepMatzyExcelDataByWSFile(file);
			}
		}
		/**
		 * ȷ��excel�����û��Զ���ı���������������ظ���
		 */

		for (int i = 0; i < dataList.size(); i++) {
			boolean isHave = false;
			Map dataMap = (Map) dataList.get(i);
			Object o;
			String wz_id = "";
			o = dataMap.get("wz_id");
			String wz_name = dataMap.get("mat_desc") != null ? dataMap.get(
					"mat_desc").toString() : "";
			Map mat = new HashMap();
			Map look = new HashMap();
			String pix = "";
			boolean isContinue = false;
			String act_price = "0";
			if (null == o) {
				if (!"".equals(wz_name) && wz_name != null) {
					String sql = "select wz_id,wz_price from gms_mat_infomation k where  k.bsflag='0'  and  k.wz_name='"
							+ wz_name + "'";
					List<Map<String, Object>> matList = jdbcTemplate
							.queryForList(sql);
					if (matList == null || matList.size() == 0) {

						isContinue = true;

					} else {
						isContinue = false;
						wz_id = matList.get(0).get("wz_id").toString();
						act_price = matList.get(0).get("wz_price").toString();
					}
				}
				if (isContinue) {
					boolean isUnique = true;
					while (isUnique) {
						String sortNoStr = "";
						String sqlno = "select sortno from gms_device_matno where id=1";
						List<Map<String, Object>> NoMapList = jdbcTemplate
								.queryForList(sqlno);
						if (null == NoMapList || NoMapList.size() <= 0) {
							sortNoStr = "1";
						} else {
							sortNoStr = NoMapList.get(0).get("sortno")
									.toString();
						}
						int sortNo = Integer.parseInt(sortNoStr) + 1;
						for (int k = 0; k < (9 - (sortNoStr.length())); k++) {
							pix += "0";

						}
						wz_id = "zy" + pix + sortNoStr;
						/**
						 * ���ʱ���Ψһ
						 */
						String sql = "select count(*) as num from gms_mat_infomation  where wz_id='"
								+ wz_id + "'";
						List<Map<String, Object>> uniqueMapList = jdbcTemplate
								.queryForList(sql);
						if (Integer.parseInt(uniqueMapList.get(0).get("num")
								.toString()) == 0) {
							mat.put("wz_id", wz_id);
							String updateSql = "update gms_device_matno set sortno="
									+ sortNo + " where id=1";
							jdbcTemplate.update(updateSql);
							isUnique = false;
							sortNoStr = "";
							pix = "";
						} else {
							sortNo = sortNo + 1;
							String updateSql = "update gms_device_matno set sortno="
									+ sortNo + " where id=1";
							jdbcTemplate.update(updateSql);
							isUnique = true;
							sortNoStr = "";
							pix = "";
						}
					}
					isHave = false;
				} else {
					isHave = true;
				}

			} else {
				wz_id = o.toString();
				if (!"".equals(wz_name) && wz_name != null) {
					String sql = "select wz_id from gms_mat_infomation k where  k.bsflag='0'  and  k.wz_name='"
							+ wz_name + "'";
					List<Map<String, Object>> matList = jdbcTemplate
							.queryForList(sql);
					if (matList == null || matList.size() == 0) {
					} else {

						wz_id = matList.get(0).get("wz_id").toString();
					}
				}
				String mat_sql = "select * from gms_mat_infomation t  where    t.bsflag='0'  and t.wz_id='"
						+ wz_id + "'";
				List<Map<String, Object>> MatMapList = jdbcTemplate
						.queryForList(mat_sql);
				// look = jdbcDao.queryRecordBySQL(mat_sql);
				if (null == MatMapList || MatMapList.size() <= 0) {
					isHave = false;
				} else {
					isHave = true;
				}
				mat.put("wz_id", wz_id);
			}
			if (!isHave) {
				mat.put("mat_desc", dataMap.get("mat_desc"));
				mat.put("wz_prickie", dataMap.get("wz_prickie"));
				mat.put("wz_price", dataMap.get("wz_price"));
				mat.put("note", dataMap.get("note"));
				mat.put("coding_code_id", "22060201");
				mat.put("wz_code", "0000000" + wz_id);
				String mat_desc = mat.get("mat_desc") == null ? "" : mat.get(
						"mat_desc").toString();
				String wz_prickie = mat.get("wz_prickie") == null ? "" : mat
						.get("wz_prickie").toString();
				String wz_price = mat.get("wz_price") == null ? act_price : mat
						.get("wz_price").toString();

				String note = mat.get("note") == null ? "" : mat.get("note")
						.toString();
				String coding_code_id = mat.get("coding_code_id") == null ? ""
						: mat.get("coding_code_id").toString();
				String wz_code = mat.get("wz_code").toString();
				String creator = user.getUserId();
				Date date = new Date();
				String insertSql = "insert into GMS_MAT_INFOMATION(wz_name,wz_id,wz_code,coding_code_id,"
						+ "wz_price,wz_prickie,mat_desc,note,creator,bsflag)"
						+ "values('"
						+ mat_desc
						+ "','"
						+ wz_id
						+ "','"
						+ wz_code
						+ "','"
						+ coding_code_id
						+ "','"
						+ wz_price
						+ "','"
						+ wz_prickie
						+ "','"
						+ mat_desc
						+ "','"
						+ note
						+ "','" + creator + "','" + 0 + "')";
				jdbcTemplate.execute(insertSql);
			}
			/**
			 * ����������Ŀ(��ʷ�����⵼������)
			 */
			String project_name = dataMap.get("project_name") == null ? ""
					: dataMap.get("project_name").toString();
			if (null != project_name && !"".equals(project_name)) {
				String sql = "select project_info_no  from gp_task_project  t where t.bsflag='0' and t.project_name='"
						+ project_name + "'";
				List<Map<String, Object>> projectList = jdbcTemplate
						.queryForList(sql);
				if (null != projectList && projectList.size() > 0) {
					projectInfoId = projectList.get(0).get("project_info_no")
							.toString();
				}
			}
			if (!"".equals(wz_id) && null != wz_id) {

				String sql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
						+ wz_id
						+ "'and t.bsflag='0' and t.project_info_id ='"
						+ projectInfoId + "'";
				List<Map<String, Object>> MatMapList = jdbcTemplate
						.queryForList(sql);

				Map repMap = new HashMap();
				// double stockNum = Double
				// .valueOf(dataMap.get("stock_num") == null ? "0" : dataMap
				// .get("stock_num").toString());
				if (MatMapList != null && MatMapList.size() > 0) {
					// stockNum +=
					// Double.valueOf(MatMapList.get(0).get("stock_num")
					// == null ? "0"
					// : MatMapList.get(0).get("stock_num").toString());
					// repMap.put("recyclemat_info",
					// MatMapList.get(0).get("recyclemat_info"));
				} else {

					String actual_price = dataMap.get("wz_price") == null ? "0"
							: dataMap.get("wz_price").toString();
					if (actual_price.equals("0")) {
						actual_price = act_price;
					}
					String wz_sequence = dataMap.get("wz_sequence") == null ? ""
							: dataMap.get("wz_sequence").toString();

					String partsno = dataMap.get("partsno") == null ? ""
							: dataMap.get("partsno").toString();
					String mat_model = dataMap.get("mat_model") == null ? ""
							: dataMap.get("mat_model").toString();
					String price = dataMap.get("price") == null ? "0" : dataMap
							.get("price").toString();
					String wz_type = "3";
					String project_info_id = projectInfoId;
					String bsflag = "0";
					String org_id = user.getOrgId();
					String ORG_SUBJECTION_ID = user.getOrgSubjectionId();
					String CREATOR_ID = user.getUserId();
					String UPDATOR_ID = user.getUserId();
					Date CREATE_DATE = new Date();
					Date MODIFI_DATE = new Date();

					String recyclemat_info = UUID.randomUUID().toString()
							.replaceAll("-", "");
					String insertSql = "insert into gms_mat_recyclemat_info(recyclemat_info,"
							+ "wz_id,actual_price,wz_sequence,partsno,"
							+ "mat_model,price,wz_type,PROJECT_INFO_ID,BSFLAG,org_id,"
							+ "ORG_SUBJECTION_ID,CREATOR,"
							+ "UPDATOR,stock_num)" + "values('"
							+ recyclemat_info
							+ "','"
							+ wz_id
							+ "',"
							+ actual_price
							+ ",'"
							+ wz_sequence
							+ "','"
							+ partsno
							+ "','"
							+ mat_model
							+ "','"
							+ price
							+ "','"
							+ wz_type
							+ "','"
							+ project_info_id
							+ "','"
							+ 0
							+ "','"
							+ org_id
							+ "','"
							+ ORG_SUBJECTION_ID
							+ "','" + CREATOR_ID + "','"

							+ UPDATOR_ID

							+ "','0')";
					jdbcTemplate.execute(insertSql);

				}
			}
		}
		return reqMsg;
	}

	/**
	 * �ɿ���Դ����excel�������ݿ����Ŀ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveExcelRepMats(ISrvMsg reqDTO) throws Exception {
		JdbcTemplate jdbcTemplate = this.jdbcDao.getJdbcTemplate();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		String org_id = user.getOrgId();
		String sub_org_id = user.getOrgSubjectionId();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		String errorMessage = null;
		/**
		 * ��ȡexcel�е�����
		 */
		List<WSFile> files = mqMsg.getFiles();
		List<Map> columnList = new ArrayList<Map>();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil
						.getRepMatzyExcelDataByWSFile(file);
			}
		}
		/**
		 * ȷ��excel�����û��Զ���ı�������
		 */
		for (int i = 0; i < dataList.size(); i++) {
			boolean isHave = false;
			Map dataMap = (Map) dataList.get(i);
			Object o;
			String wz_id = "";
			o = dataMap.get("wz_id");
			String wz_name = dataMap.get("mat_desc") != null ? dataMap.get(
					"mat_desc").toString() : "";
			Map mat = new HashMap();
			Map look = new HashMap();
			String pix = "";
			String act_price = "0";

			/**
			 * ��ȡ��excel�������ʱ���
			 */
			if (null == o) {
				/**
				 * ��Դ���ʱ������
				 */
				boolean isContinue = false;
				if (!"".equals(wz_name) && wz_name != null) {
					String sql = "select wz_id,wz_price from gms_mat_infomation k where  k.bsflag='0'  and  k.wz_name='"
							+ wz_name + "'";
					List<Map<String, Object>> matList = jdbcTemplate
							.queryForList(sql);
					if (matList == null || matList.size() == 0) {

						isContinue = true;

					} else {
						isContinue = false;
						wz_id = matList.get(0).get("wz_id").toString();
						act_price = matList.get(0).get("wz_price").toString();
					}
				}
				if (isContinue) {

					boolean isUnique = true;
					while (isUnique) {

						String sortNoStr = "";
						String sqlno = "select sortno from gms_device_matno where id=1";
						List<Map<String, Object>> NoMapList = jdbcTemplate
								.queryForList(sqlno);
						if (null != NoMapList && NoMapList.size() > 0) {
							sortNoStr = NoMapList.get(0).get("sortno")
									.toString();
						} else {
							sortNoStr = "1";
						}
						// Map result = jdbcDao.queryRecordBySQL(sqlno);
						// sortNoStr = result.get("sortno").toString();
						int sortNo = Integer.parseInt(sortNoStr) + 1;
						/**
						 * ��Դ�����м䲿��
						 */
						for (int k = 0; k < (9 - (sortNoStr.length())); k++) {
							pix += "0";

						}
						wz_id = "zy" + pix + sortNoStr;
						String sql = "select count(*) as num from gms_mat_infomation  where wz_id='"
								+ wz_id + "'";
						List<Map<String, Object>> uniqueMapList = jdbcTemplate
								.queryForList(sql);
						if (Integer.parseInt(uniqueMapList.get(0).get("num")
								.toString()) == 0) {
							mat.put("wz_id", wz_id);
							String updateSql = "update gms_device_matno set sortno="
									+ sortNo + " where id=1";
							jdbcTemplate.update(updateSql);
							isUnique = false;
							sortNoStr = "";
							pix = "";
						} else {
							sortNo = sortNo + 1;
							String updateSql = "update gms_device_matno set sortno="
									+ sortNo + " where id=1";
							jdbcTemplate.update(updateSql);
							isUnique = true;
							sortNoStr = "";
							pix = "";
						}
					}
					isHave = false;
				} else {
					isHave = true;
				}

			} else {
				/**
				 * �����Excel�д������ʱ���
				 */
				wz_id = o.toString();
				if (!"".equals(wz_name) && wz_name != null) {
					String sql = "select wz_id from gms_mat_infomation k where  k.bsflag='0'  and  k.wz_name='"
							+ wz_name + "'";
					List<Map<String, Object>> matList = jdbcTemplate
							.queryForList(sql);
					if (matList == null || matList.size() == 0) {
					} else {

						wz_id = matList.get(0).get("wz_id").toString();
					}
				}
				String mat_sql = "select * from gms_mat_infomation t  where   t.bsflag='0'  and   t.wz_id='"
						+ wz_id + "'";
				List<Map<String, Object>> matMapList = jdbcTemplate
						.queryForList(mat_sql);
				// look = jdbcDao.queryRecordBySQL(mat_sql);
				if (null == matMapList || matMapList.size() <= 0) {
					// ���ʲ�����
					isHave = false;
				} else {
					// ����
					isHave = true;
				}
				mat.put("wz_id", wz_id);
			}
			if (!isHave) {
				mat.put("mat_desc", dataMap.get("mat_desc"));
				mat.put("wz_prickie", dataMap.get("wz_prickie"));
				mat.put("wz_price", dataMap.get("wz_price"));
				mat.put("note", dataMap.get("note"));
				mat.put("coding_code_id", "22060201");
				mat.put("wz_code", "0000000" + wz_id);
				String mat_desc = mat.get("mat_desc") == null ? "" : mat.get(
						"mat_desc").toString();
				String wz_prickie = mat.get("wz_prickie") == null ? "" : mat
						.get("wz_prickie").toString();
				String wz_price = mat.get("wz_price") == null ? act_price : mat
						.get("wz_price").toString();

				String note = mat.get("note") == null ? "" : mat.get("note")
						.toString();
				String coding_code_id = mat.get("coding_code_id") == null ? ""
						: mat.get("coding_code_id").toString();
				String wz_code = mat.get("wz_code").toString();
				String creator = user.getUserId();
				Date date = new Date();
				String insertSql = "insert into GMS_MAT_INFOMATION(wz_name,wz_id,wz_code,coding_code_id,"
						+ "wz_price,wz_prickie,mat_desc,note,creator,bsflag)"
						+ "values('"
						+ mat_desc
						+ "','"
						+ wz_id
						+ "','"
						+ wz_code
						+ "','"
						+ coding_code_id
						+ "','"
						+ wz_price
						+ "','"
						+ wz_prickie
						+ "','"
						+ mat_desc
						+ "','"
						+ note
						+ "','" + creator + "','" + 0 + "')";
				// pureDao.executeUpdate(insertSql);
				// this.saveMat(insertSql);
				jdbcTemplate.update(insertSql);
			}
			if (sub_org_id.length() <= 10) {
				sub_org_id = sub_org_id;
			} else {
				sub_org_id = sub_org_id.substring(0, 10);
			}
			if (!"".equals(wz_id) && null != wz_id) {

				String sql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
						+ wz_id
						+ "' and  t.wz_type='3' and t.bsflag='0' and t.org_subjection_id   like '%"
						+ sub_org_id + "%'  and  project_info_id is  null ";
				// Map getMap = jdbcDao.queryRecordBySQL(sql);
				// Map getMap = this.queryMat(sql);
				List<Map<String, Object>> recyMapList = jdbcTemplate
						.queryForList(sql);
				Map repMap = new HashMap();
				// double stockNum = Double.valueOf(dataMap.get("stock_num") ==
				// null
				// ? "0" : dataMap
				// .get("stock_num").toString());
				if (recyMapList != null && recyMapList.size() > 0) {
					// stockNum += Double
					// .valueOf(recyMapList.get(0).get("stock_num") == null ?
					// "0"
					// : recyMapList.get(0).get("stock_num")
					// .toString());
					// repMap.put("recyclemat_info",
					// recyMapList.get(0).get("recyclemat_info"));
				} else {
					String actual_price = dataMap.get("wz_price") == null ? "0"
							: dataMap.get("wz_price").toString();
					if (actual_price.equals("0")) {
						actual_price = act_price;
					}
					String wz_sequence = dataMap.get("wz_sequence") == null ? ""
							: dataMap.get("wz_sequence").toString();

					String partsno = dataMap.get("partsno") == null ? ""
							: dataMap.get("partsno").toString();
					String mat_model = dataMap.get("mat_model") == null ? ""
							: dataMap.get("mat_model").toString();
					String price = dataMap.get("price") == null ? "0" : dataMap
							.get("price").toString();
					String wz_type = "3";
					String project_info_id = projectInfoId;
					String bsflag = "0";

					String ORG_SUBJECTION_ID = user.getOrgSubjectionId();
					String CREATOR_ID = user.getUserId();
					String UPDATOR_ID = user.getUserId();
					Date CREATE_DATE = new Date();
					Date MODIFI_DATE = new Date();

					String recyclemat_info = UUID.randomUUID().toString()
							.replaceAll("-", "");
					String insertSql = "insert into gms_mat_recyclemat_info(recyclemat_info,"
							+ "wz_id,actual_price,wz_sequence,partsno,"
							+ "mat_model,price,wz_type,BSFLAG,org_id,"
							+ "ORG_SUBJECTION_ID,CREATOR,"
							+ "UPDATOR,stock_num)" + "values('"
							+ recyclemat_info
							+ "','"
							+ wz_id
							+ "',"
							+ actual_price
							+ ",'"
							+ wz_sequence
							+ "','"
							+ partsno
							+ "','"
							+ mat_model
							+ "','"
							+ price
							+ "','"
							+ wz_type
							+ "','"
							+ 0
							+ "','"
							+ user.getOrgId()
							+ "','"
							+ ORG_SUBJECTION_ID
							+ "','" + CREATOR_ID

							+ "','" + UPDATOR_ID

							+ "','0')";
					jdbcTemplate.execute(insertSql);
				}
			}

		}
		return reqMsg;
	}

	/**
	 * �����ƻ�-����ά�޼�¼
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getByjhDetailInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String dev_acc_id = msg.getValue("dev_acc_id");
		String querySql = "select * from gms_device_zy_bywx t where t.dev_acc_id='"
				+ dev_acc_id
				+ "' and t.project_info_id= '"
				+ user.getProjectInfoNo() + "'";
		List<Map> byjhList = this.jdbcDao.queryRecords(querySql);
		responseDTO.setValue("datas", byjhList);
		return responseDTO;
	}

	/**
	 * ��ѯ�ɿ���ԴID �����Ա�� ajax
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZyInfoForSelfNum(ISrvMsg isrvmsg) throws Exception {

		UserToken user = isrvmsg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer sqlBuffer = new StringBuffer();
		String self_num = isrvmsg.getValue("self_num");
		String querySql = "select dev_acc_id from gms_device_account_dui dui where dui.project_info_id='"
				+ projectInfoNo
				+ "' and dui.dev_type like 'S062301%' and dui.self_num='"
				+ self_num + "' ";
		Map bjMap = this.jdbcDao.queryRecordBySQL(querySql);
		responseDTO.setValue("data", bjMap);
		return responseDTO;
	}

	/**
	 * ��ѯ�ɿ���ԴID �����Ա�� ajax
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZyInfoForSelfNums(ISrvMsg isrvmsg) throws Exception {

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer sqlBuffer = new StringBuffer();
		String self_num = isrvmsg.getValue("self_num");
		// String querySql =
		// "select dev_acc_id from gms_device_account dui where dui.owning_sub_id like '"
		// + user.getOrgSubjectionId()
		// +
		// "%' and  dui.account_stat='0110000013000000003' and dui.dev_type like 'S062301%' and dui.self_num='"
		// + self_num + "' ";

		String querySql = "select dev_acc_id from gms_device_account dui where  "
				+ "   dui.account_stat='0110000013000000003' and dui.dev_type like 'S062301%' and dui.self_num='"
				+ self_num + "' ";
		Map bjMap = this.jdbcDao.queryRecordBySQL(querySql);
		responseDTO.setValue("data", bjMap);
		return responseDTO;
	}

	/**
	 * ���汣��ά����������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savewxbyMat(ISrvMsg isrvmsg) throws Exception {
		log.info("savewxbyMat");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		// ��������
		String use_num = isrvmsg.getValue("use_num");
		// �������
		String coding_code_id = isrvmsg.getValue("coding_code_id");
		// ���ʱ���
		String wz_id = isrvmsg.getValue("wz_id");
		String usemat_id = isrvmsg.getValue("usemat_id");
		Map map = new HashMap();
		map.put("use_num", use_num);
		map.put("coding_code_id", coding_code_id);
		map.put("wz_id", wz_id);
		map.put("usemat_id", usemat_id);
		map.put("creator", user.getUserId());
		map.put("create_date", currentdate);
		jdbcDao.saveOrUpdateEntity(map, "gms_device_zy_wxbymat");
		return responseDTO;
	}

	/**
	 * ɾ�� ��������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg deleteRepMat(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update GMS_MAT_RECYCLEMAT_INFO set bsflag = '1' where recyclemat_info = '"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * ��ѯ����Ŀ��������
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getwxbyMatInfos(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String wz_name = msg.getValue("wz_name");
		if (wz_name.equals("undefined")) {
			wz_name = "";
		}
		String querysgllSql = "select i.*, c.code_name,tt.postion, tt.stock_num,tt.actual_price,tt.wz_sequence from (select  t.wz_id,t.wz_sequence,t.stock_num,t.actual_price,t.postion  from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'  and t.wz_sequence is  null   and t.project_info_id is null and   t.org_subjection_id like '"
				+ user.getSubOrgIDofAffordOrg()
				+ "%' ) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on tt.wz_id=i.wz_id   and   i.wz_name  like '%"
				+ wz_name
				+ "%'  order  by tt.postion asc , i.coding_code_id asc ,i.wz_id asc";

		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	public ISrvMsg getwxbyZcjMatInfos(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String wz_name = msg.getValue("wz_name");
		if (wz_name.equals("undefined")) {
			wz_name = "";
		}
		String querysgllSql = "select i.*, c.code_name,tt.postion, tt.stock_num,tt.actual_price,tt.wz_sequence from (select  t.wz_id,t.wz_sequence,t.stock_num,t.actual_price,t.postion  from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'  and  t.project_info_id is null and   t.org_subjection_id like '"
				+ user.getSubOrgIDofAffordOrg()
				+ "%' ) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on tt.wz_id=i.wz_id   and   i.wz_name  like '%"
				+ wz_name
				+ "%'  order  by tt.postion asc , i.coding_code_id asc ,i.wz_id asc";

		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ģ����ѯ�Ա��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getLikeSelfNum(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String self_num = msg.getValue("self_num");
		String querysgllSql = "select self_num   from gms_device_account t where   t.dev_type  like 'S06230101%' and t.bsflag='0' and t.self_num like '%"
				+ self_num + "%' ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ��ĿID�ַ���
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectInfoIdList(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String bywx_date_begin = msg.getValue("bywx_date_begin");
		String bywx_date_end = msg.getValue("bywx_date_end");
		String sql = "select distinct project_info_no   from gp_task_project p   "
				+ " where project_info_no in ( select wx.project_info_id from gms_device_zy_bywx  wx where wx.bsflag='0' and wx.bywx_date >= to_date('"
				+ bywx_date_begin
				+ "', 'yyyy-mm-dd')"
				+ "and wx.bywx_date <= to_date('"
				+ bywx_date_end
				+ "', 'yyyy-mm-dd')) and p.bsflag='0'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(sql);
		String pids = "";
		for (Map map : list) {
			String pid = map.get("project_info_no") != null ? map.get(
					"project_info_no").toString() : "0";
			pids += pid + ",";
		}
		pids += ",0";
		responseDTO.setValue("data", pids);
		return responseDTO;
	}

	/**
	 * ���������б�
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getUseMatList(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String wz_name = msg.getValue("wz_name");
		String querysgllSql = "select  distinct m.wz_id, wz_name, m.wz_prickie, m.wz_price"
				+ "  from gms_mat_infomation m, gms_mat_recyclemat_info r  "
				+ "  where r.wz_id = m.wz_id  "
				+ "   and r.wz_type='3'  "
				+ "  and r.bsflag='0'  "
				+ "  and m.wz_id   in  (select wz_id from gms_device_zy_wxbymat ) and  m.wz_name like '%"
				+ wz_name + "%'";

		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	public ISrvMsg getwxbyMatInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String wz_name = msg.getValue("wz_name");
		if (wz_name.equals("undefined")) {
			wz_name = "";
		}
		String querysgllSql = "select i.*, c.code_name,tt.postion, tt.stock_num,tt.actual_price,tt.wz_sequence from (select  t.wz_id,t.wz_sequence,t.stock_num, t.actual_price,t.postion  from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'   and wz_sequence is  null   and t.project_info_id='"
				+ user.getProjectInfoNo()
				+ "' ) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0' ) on tt.wz_id=i.wz_id   where i.wz_name like '%"
				+ wz_name
				+ "%' order by tt.postion asc,i.coding_code_id asc ,i.wz_id asc";

		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	public ISrvMsg getwxbyZcjMatInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String wz_name = msg.getValue("wz_name");
		if (wz_name.equals("undefined")) {
			wz_name = "";
		}
		String querysgllSql = "select i.*, c.code_name,tt.postion, tt.stock_num,tt.actual_price,tt.wz_sequence from (select  t.wz_id,t.wz_sequence,t.stock_num, t.actual_price,t.postion  from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'  and   t.project_info_id='"
				+ user.getProjectInfoNo()
				+ "' ) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0' ) on tt.wz_id=i.wz_id   where i.wz_name like '%"
				+ wz_name
				+ "%' order by tt.postion asc,i.coding_code_id asc ,i.wz_id asc";

		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ��ѯ����Ŀ��������������ʱ���ID��ѯ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getwxbyMatInfosId(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String bywx_id = msg.getValue("bywx_id");
		String querySql = "select info.wz_sequence,info.wz_id,info.actual_price,info.stock_num,i.wz_name,i.wz_prickie,mat.use_num,d.coding_name from gms_device_zy_wxbymat mat   left join gms_device_zy_bywx l on  l.usemat_id=mat.usemat_id ";
		querySql += " left join gms_mat_recyclemat_info info on info.wz_id=mat.wz_id and info.bsflag='0'  and info.project_info_id is null and info.ORG_SUBJECTION_ID like '"
				+ user.getSubOrgIDofAffordOrg() + "%'    and info.wz_type='3'";
		querySql += " left join comm_coding_sort_detail d on d.coding_code_id=mat.coding_code_id ";
		querySql += " inner join(gms_mat_infomation i  inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id ";
		querySql += " and i.bsflag = '0' and c.bsflag = '0') on mat.wz_id=i.wz_id   where l.bywx_id='"
				+ bywx_id + "' ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querySql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/* �����豸ά�ޱ�����¼ */
	public ISrvMsg saveDeviceAccountRepairInfo(ISrvMsg isrvmsg)
			throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		Map codeMap = new HashMap();
		codeMap.put("1", "��");
		codeMap.put("2", "̨");
		codeMap.put("3", "ֻ");
		Map map = new HashMap();
		String repair_info = isrvmsg.getValue("repair_info");
		if (StringUtils.isNotBlank(repair_info) && !repair_info.equals("null")) {
			map.put("repair_info", repair_info);
			String sqlString = "delete from BGP_COMM_DEVICE_REPAIR_DETAIL where repair_info='"
					+ repair_info + "'";
			jdbcDao.executeUpdate(sqlString);
			String sqlString2 = "delete from BGP_COMM_DEVICE_REPAIR_TYPE where repair_info='"
					+ repair_info + "'";
			jdbcDao.executeUpdate(sqlString2);
		}
		String record_status = isrvmsg.getValue("record_status");
		String tech_stat = isrvmsg.getValue("tech_stat");
		// ���������̨���еļ���״����ʹ��״�� ���
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000001")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000001' , account.USING_STAT='0110000007000000002' where account.dev_acc_id='"
					+ isrvmsg.getValue("dev_appdet_id") + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}
		// ���� ����̨�ʵ�ʹ��״̬Ϊ���� ����״̬Ϊ����
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000007")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000007' , account.USING_STAT='0110000007000000006' where account.dev_acc_id='"
					+ isrvmsg.getValue("dev_appdet_id") + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}
		// ������ ����̨�ʵ�ʹ��״̬Ϊ���� ����״̬Ϊ����
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000005")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000005' , account.USING_STAT='0110000007000000006' where account.dev_acc_id='"
					+ isrvmsg.getValue("dev_appdet_id") + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}

		map.put("record_status", isrvmsg.getValue("record_status"));
		map.put("DEVICE_ACCOUNT_ID", isrvmsg.getValue("dev_appdet_id"));
		map.put("REPAIR_TYPE", isrvmsg.getValue("repairType"));
		map.put("REPAIR_LEVEL", isrvmsg.getValue("repairLevel"));
		map.put("REPAIR_ITEM", isrvmsg.getValue("repairItem"));
		map.put("REPAIR_START_DATE", isrvmsg.getValue("REPAIR_START_DATE"));
		map.put("REPAIR_END_DATE", isrvmsg.getValue("REPAIR_END_DATE"));
		map.put("HUMAN_COST", isrvmsg.getValue("HUMAN_COST"));
		map.put("MATERIAL_COST", isrvmsg.getValue("MATERIAL_COST"));
		map.put("CREATOR", isrvmsg.getUserToken().getUserName());
		map.put("REPAIRER", isrvmsg.getValue("REPAIRER"));
		map.put("ACCEPTER", isrvmsg.getValue("ACCEPTER"));
		map.put("REPAIR_DETAIL", isrvmsg.getValue("REPAIR_DETAIL"));
		map.put("RECORD_STATUS", isrvmsg.getValue("RECORD_STATUS"));
		String mk = (String) jdbcDao.saveOrUpdateEntity(map,
				"BGP_COMM_DEVICE_REPAIR_INFO");
		List rows = isrvmsg.getCheckBoxValues("rows");

		// System.out.println(isrvmsg.getValue("repairItem"));
		if ("0110000038000000015".equals(isrvmsg.getValue("repairItem"))) {
			Map map2 = new HashMap();
			map2.put("NEXT_MAINTAIN_DATE",
					isrvmsg.getValue("REPAIR_START_DATE"));
			map2.put("DEVICE_ACCOUNT_ID", isrvmsg.getValue("dev_appdet_id"));
			jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_MAINTAIN");
		}

		// ������Ŀ--------------------------------����������û��ѡ�е�ѡ��(���ֳֻ�����һ��)
		String qzby_value = isrvmsg.getValue("qzby_value");
		if (qzby_value != null) {
			String temp[] = qzby_value.split(",");
			String[] updateSql = new String[temp.length];
			for (int j = 0; j < temp.length; j++) {
				// Map map1=new HashMap();
				// map1.put("REPAIR_INFO", mk);
				// map1.put("CREATOR_ID", isrvmsg.getUserToken().getUserId());
				// map1.put("CREATE_DATE", new Date());
				// map1.put("UPDATOR_ID", isrvmsg.getUserToken().getUserId());
				// map1.put("MODIFI_DATE", new Date());
				// map1.put("BSFLAG", "0");
				// map1.put("TYPE_ID", temp[j]);//������Ŀ����
				//
				// //�豸������Ŀ�б�
				// jdbcDao.saveOrUpdateEntity(map1,
				// "BGP_COMM_DEVICE_REPAIR_TYPE");

				String sql = "insert into BGP_COMM_DEVICE_REPAIR_TYPE (repair_detail_id,repair_info,creator_id,create_date,updator_id,modifi_date,bsflag,type_id) "
						+ "values((select sys_guid() from dual),'"
						+ mk
						+ "','"
						+ isrvmsg.getUserToken().getUserId()
						+ "',sysdate,'"
						+ isrvmsg.getUserToken().getUserId()
						+ "',sysdate,'0','" + temp[j] + "')";
				updateSql[j] = sql;
			}
			jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		}

		if (rows != null) {
			for (int i = 0; i < rows.size(); i++) {
				Map map1 = new HashMap();
				map1.put("REPAIR_INFO", mk);
				map1.put("CREATOR", isrvmsg.getUserToken().getUserName());
				map1.put("CREATE_DATE", currentdate);
				map1.put("teammat_out_id",
						isrvmsg.getValue("teammat_out_id" + rows.get(i)));// �ƻ�����
				map1.put("MATERIAL_SPEC",
						isrvmsg.getValue("use_info_detail" + rows.get(i)));// ���ĵĲ�������
				map1.put("MATERIAL_NAME",
						isrvmsg.getValue("wz_name" + rows.get(i)));// ��������
				map1.put("MATERIAL_CODING",
						isrvmsg.getValue("wz_id" + rows.get(i)));// ���ϱ��
				map1.put("UNIT_PRICE",
						isrvmsg.getValue("wz_price" + rows.get(i)));// ����
				map1.put("OUT_NUM", isrvmsg.getValue("use_num" + rows.get(i)));// ��������
				map1.put("MATERIAL_AMOUT",
						isrvmsg.getValue("asign_num" + rows.get(i)));// ��������
				map1.put("TOTAL_CHARGE",
						isrvmsg.getValue("total_charge" + rows.get(i)));// �ܼ�

				// �����ӱ�
				jdbcDao.saveOrUpdateEntity(map1,
						"BGP_COMM_DEVICE_REPAIR_DETAIL");
				// Map map2=new HashMap();
				// map2.put("use_info_detail",
				// isrvmsg.getValue("use_info_detail"+rows.get(i)));
				// map2.put("dev_use", "9");
				// jdbcDao.saveOrUpdateEntity(map2,
				// "GMS_MAT_DEVICE_USE_INFO_DETAIL");

			}
		}

		return responseDTO;
	}

	/* �����豸ά�ޱ�����¼ */
	public ISrvMsg saveDeviceRepairInfo(ISrvMsg isrvmsg) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		Map codeMap = new HashMap();
		codeMap.put("1", "��");
		codeMap.put("2", "̨");
		codeMap.put("3", "ֻ");
		Map map = new HashMap();
		String repair_info = isrvmsg.getValue("repair_info");
		if (StringUtils.isNotBlank(repair_info) && !repair_info.equals("null")) {
			map.put("repair_info", repair_info);
			String sqlString = "delete from BGP_COMM_DEVICE_REPAIR_DETAIL where repair_info='"
					+ repair_info + "'";
			jdbcDao.executeUpdate(sqlString);
			String sqlString2 = "delete from BGP_COMM_DEVICE_REPAIR_TYPE where repair_info='"
					+ repair_info + "'";
			jdbcDao.executeUpdate(sqlString2);
		}
		map.put("DEVICE_ACCOUNT_ID", isrvmsg.getValue("dev_appdet_id"));
		map.put("REPAIR_TYPE", isrvmsg.getValue("repairType"));
		map.put("REPAIR_ITEM", isrvmsg.getValue("repairItem"));
		map.put("REPAIR_START_DATE", isrvmsg.getValue("REPAIR_START_DATE"));
		map.put("REPAIR_END_DATE", isrvmsg.getValue("REPAIR_END_DATE"));
		map.put("HUMAN_COST", isrvmsg.getValue("HUMAN_COST"));
		map.put("MATERIAL_COST", isrvmsg.getValue("MATERIAL_COST"));
		map.put("CREATOR", isrvmsg.getUserToken().getUserName());
		map.put("REPAIRER", isrvmsg.getValue("REPAIRER"));
		map.put("ACCEPTER", isrvmsg.getValue("ACCEPTER"));
		map.put("REPAIR_DETAIL", isrvmsg.getValue("REPAIR_DETAIL"));
		map.put("RECORD_STATUS", isrvmsg.getValue("RECORD_STATUS"));
		String mk = (String) jdbcDao.saveOrUpdateEntity(map,
				"BGP_COMM_DEVICE_REPAIR_INFO");
		List rows = isrvmsg.getCheckBoxValues("rows");

		// System.out.println(isrvmsg.getValue("repairItem"));
		if ("0110000038000000015".equals(isrvmsg.getValue("repairItem"))) {
			Map map2 = new HashMap();
			map2.put("NEXT_MAINTAIN_DATE",
					isrvmsg.getValue("REPAIR_START_DATE"));
			map2.put("DEVICE_ACCOUNT_ID", isrvmsg.getValue("dev_appdet_id"));
			jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_MAINTAIN");
		}

		// ������Ŀ--------------------------------����������û��ѡ�е�ѡ��(���ֳֻ�����һ��)
		String qzby_value = isrvmsg.getValue("qzby_value");
		if (qzby_value != null) {
			String temp[] = qzby_value.split(",");
			String[] updateSql = new String[temp.length];
			for (int j = 0; j < temp.length; j++) {
				// Map map1=new HashMap();
				// map1.put("REPAIR_INFO", mk);
				// map1.put("CREATOR_ID", isrvmsg.getUserToken().getUserId());
				// map1.put("CREATE_DATE", new Date());
				// map1.put("UPDATOR_ID", isrvmsg.getUserToken().getUserId());
				// map1.put("MODIFI_DATE", new Date());
				// map1.put("BSFLAG", "0");
				// map1.put("TYPE_ID", temp[j]);//������Ŀ����
				//
				// //�豸������Ŀ�б�
				// jdbcDao.saveOrUpdateEntity(map1,
				// "BGP_COMM_DEVICE_REPAIR_TYPE");

				String sql = "insert into BGP_COMM_DEVICE_REPAIR_TYPE (repair_detail_id,repair_info,creator_id,create_date,updator_id,modifi_date,bsflag,type_id) "
						+ "values((select sys_guid() from dual),'"
						+ mk
						+ "','"
						+ isrvmsg.getUserToken().getUserId()
						+ "',sysdate,'"
						+ isrvmsg.getUserToken().getUserId()
						+ "',sysdate,'0','" + temp[j] + "')";
				updateSql[j] = sql;
			}
			jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		}

		if (rows != null) {
			for (int i = 0; i < rows.size(); i++) {
				Map map1 = new HashMap();
				map1.put("REPAIR_INFO", mk);
				map1.put("CREATOR", isrvmsg.getUserToken().getUserName());
				map1.put("CREATE_DATE", currentdate);
				map1.put("teammat_out_id",
						isrvmsg.getValue("teammat_out_id" + rows.get(i)));// �ƻ�����
				map1.put("MATERIAL_SPEC",
						isrvmsg.getValue("use_info_detail" + rows.get(i)));// ���ĵĲ�������
				map1.put("MATERIAL_NAME",
						isrvmsg.getValue("wz_name" + rows.get(i)));// ��������
				map1.put("MATERIAL_CODING",
						isrvmsg.getValue("wz_id" + rows.get(i)));// ���ϱ��
				map1.put("UNIT_PRICE",
						isrvmsg.getValue("wz_price" + rows.get(i)));// ����
				map1.put("OUT_NUM", isrvmsg.getValue("use_num" + rows.get(i)));// ��������
				map1.put("MATERIAL_AMOUT",
						isrvmsg.getValue("asign_num" + rows.get(i)));// ��������
				map1.put("TOTAL_CHARGE",
						isrvmsg.getValue("total_charge" + rows.get(i)));// �ܼ�

				// �����ӱ�
				jdbcDao.saveOrUpdateEntity(map1,
						"BGP_COMM_DEVICE_REPAIR_DETAIL");
				// Map map2=new HashMap();
				// map2.put("use_info_detail",
				// isrvmsg.getValue("use_info_detail"+rows.get(i)));
				// map2.put("dev_use", "9");
				// jdbcDao.saveOrUpdateEntity(map2,
				// "GMS_MAT_DEVICE_USE_INFO_DETAIL");

			}
		}

		return responseDTO;
	}

	/**
	 * ��ѯ����ά�޼�¼
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String repair_info = msg.getValue("repair_info");
		String querySql = "select info.*,account.dev_name,account.dev_model,account.self_num,account.license_num   "
				+ ",(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=info.repair_type) as repairtype,"
				+ " (select c.coding_name from comm_coding_sort_detail c where c.coding_code_id=info.repair_item) as repairitem,(select c.coding_name from comm_coding_sort_detail c where c.coding_code_id=info.repair_level) as repairLevel  from bgp_comm_device_repair_info info  left join GMS_DEVICE_ACCOUNT ACCOUNT on ACCOUNT.DEV_ACC_ID=INFO.DEVICE_ACCOUNT_ID ";

		querySql += " where info.repair_info='" + repair_info + "'";
		Map repairInfoMap = this.jdbcDao.queryRecordBySQL(querySql);
		responseDTO.setValue("deviceaccMap", repairInfoMap);
		return responseDTO;
	}

	/**
	 * �����ƻ�����
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDeviceMaintenancePlan(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// ��ȡ��Ŀ��
		String projectInfoNo = user.getProjectInfoNo();
		// ��ȡ������
		Map map = msg.toMap();
		// ���ӻ��޸ı�ʶ
		String flag = msg.getValue("flag");
		// �޸Ĳ���
		if ("update".equals(flag)) {
			String sql = "delete from gms_device_maintenance_plan t where t.dev_acc_id = '"
					+ map.get("dev_acc_id").toString() + "'";
			jdbcDao.executeUpdate(sql);
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String strDate = map.get("last_by_time").toString();// ���������
		Date date = sdf.parse(strDate);
		// ��ѯ��Ŀ�ļƻ���ʼʱ��ͽ���ʱ�����ɱ�����¼
		String projectSql = "select case when dui.planning_out_time is not null then  dui.planning_out_time "
				+ " else pro.project_end_time end as actual_end_time  from gms_device_account_dui dui"
				+ " left join gp_task_project pro on dui.project_info_id=pro.project_info_no"
				+ " where dui.bsflag='0' and dui.dev_acc_id = '"
				+ map.get("dev_acc_id").toString() + "'";
		Map projectMap = jdbcDao.queryRecordBySQL(projectSql);
		// ����������Ϣ
		String maintenance_cycle = map.get("maintenance_cycle").toString()
				.trim();
		int cyclevalue = Integer.parseInt("".equals(maintenance_cycle) ? "0"
				: maintenance_cycle);
		Date planEndDate = sdf.parse(projectMap.get("actual_end_time")
				.toString());// �ƻ��볡ʱ��
		if (cyclevalue > 0) {
			Date d = date;
			d = DateUtils.addDays(d, cyclevalue);
			int i = 1;
			for (; d.before(planEndDate);) {
				Map<String, Object> Map_Maint = new HashMap<String, Object>();
				Map_Maint.put("dev_acc_id", map.get("dev_acc_id").toString());// �Ӽ��豸����
				Map_Maint.put("fk_dev_acc_id", map.get("fk_dev_acc_id")
						.toString());// �豸��̨������
				Map_Maint.put("project_info_id", projectInfoNo);// ��Ŀ���
				Map_Maint.put("actual_time", date);// ʵ�ʱ���ʱ��
				Map_Maint.put("plan_num", i);// �ƻ���������
				Map_Maint.put("last_maintenance_time", date);// �����ʱ��
				Map_Maint.put("maintenance_cycle", map.get("maintenance_cycle")
						.toString());// ��������
				Map_Maint.put("planning_out_time",
						projectMap.get("actual_end_time"));// �豸�ƻ��볡ʱ��
				Map_Maint.put("plan_date", sdf.format(d));// �ƻ�����ʱ��
				jdbcDao.saveOrUpdateEntity(Map_Maint,
						"gms_device_maintenance_plan");
				d = DateUtils.addDays(d, cyclevalue);
				i++;
			}
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * ����Ŀ�����ƻ�����
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDeviceAccMaintenancePlan(ISrvMsg msg) throws Exception {

		UserToken user = msg.getUserToken();
		// �Ӽ�̨��ID
		String devAccId = msg.getValue("ids");
		// ��Ŀ���
		String projectInfoNo = "";
		// ���Ӽ�̨��Ϊ����,��������Ŀ���
		if (devAccId != null && !devAccId.equals("")) {
			projectInfoNo = user.getProjectInfoNo();
		}
		// ��̨��ID
		String fkDevAccId = msg.getValue("fk_dev_acc_id");
		// ��������
		Integer count = Integer.parseInt(msg.getValue("count"));
		Map<String, Object> map = new HashMap<String, Object>();
		for (int i = 1; i <= count; i++) {
			map.put("maintenance_id", msg.getValue("maintenance_id" + i));
			map.put("dev_acc_id", devAccId);
			map.put("fk_dev_acc_id", fkDevAccId);
			map.put("project_info_id", projectInfoNo);
			map.put("plan_num", i);
			// ���뱣��ʱ��
			map.put("plan_date", msg.getValue("by_date" + i));
			// �����ۼ����
			map.put("mileage", msg.getValue("mileage" + i));
			// �����ۼƹ���Сʱ
			map.put("work_hour", msg.getValue("work_hour" + i));
			jdbcDao.saveOrUpdateEntity(map, "gms_device_maintenance_plan");
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * ��Ŀ�����ƻ��޸�
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateDeviceAccMaintenancePlan(ISrvMsg msg) throws Exception {

		UserToken user = msg.getUserToken();
		// �Ӽ�̨��ID
		String devAccId = msg.getValue("ids");
		// ��Ŀ���
		String projectInfoNo = "";
		// ���Ӽ�̨��Ϊ����,��������Ŀ���
		if (devAccId != null && !devAccId.equals("")) {
			projectInfoNo = user.getProjectInfoNo();
			// �����޸�ʱ,���֮ǰ�ļƻ�
			String sql = "delete from gms_device_maintenance_plan t where t.dev_acc_id = '"
					+ devAccId + "'";
			jdbcDao.executeUpdate(sql);
		}
		// ��̨��ID
		String fkDevAccId = msg.getValue("fk_dev_acc_id");

		// ��������
		Integer count = Integer.parseInt(msg.getValue("count"));
		Map<String, Object> map = new HashMap<String, Object>();
		for (int i = 1; i <= count; i++) {
			map.put("maintenance_id", msg.getValue("maintenance_id" + i));
			map.put("dev_acc_id", devAccId);
			map.put("fk_dev_acc_id", fkDevAccId);
			map.put("project_info_id", projectInfoNo);
			map.put("plan_num", i);
			// ���뱣��ʱ��
			map.put("plan_date", msg.getValue("by_date" + i));
			jdbcDao.saveEntity(map, "gms_device_maintenance_plan");
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * �����ƻ�ɾ��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delDeviceMaintenancePlan(ISrvMsg msg) throws Exception {
		String devAccId = msg.getValue("deviceId");// �Ӽ�̨��ID
		String fkDevId = msg.getValue("fkDevId"); // ��̨��ID
		// ��������
		if (devAccId != null) {
			String sql = "delete from gms_device_maintenance_plan t where t.dev_acc_id = '"
					+ devAccId + "'";
			jdbcDao.executeUpdate(sql);
		}
		if (fkDevId != null) {
			String sql = "delete from gms_device_maintenance_plan t where t.fk_dev_acc_id = '"
					+ fkDevId + "'";
			jdbcDao.executeUpdate(sql);
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * ����Ŀ�����ƻ�ɾ��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delDeviceAccMaintenancePlan(ISrvMsg msg) throws Exception {
		String devAccId = msg.getValue("deviceId");// �Ӽ�̨��ID
		String fkDevId = msg.getValue("fkDevId"); // ��̨��ID
		// ��������
		if (devAccId != null) {
			String sql = "delete from gms_device_maintenance_plan t where t.dev_acc_id = '"
					+ devAccId + "'";
			jdbcDao.executeUpdate(sql);
		}
		if (fkDevId != null) {
			String sql = "delete from gms_device_maintenance_plan t where t.fk_dev_acc_id = '"
					+ fkDevId + "'";
			jdbcDao.executeUpdate(sql);
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}

	/**
	 * �����ƻ���ѯ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	// public ISrvMsg getDeviceMaintenancePlan(ISrvMsg msg) throws Exception {
	// ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	//
	// UserToken user = msg.getUserToken();
	// //��Ŀ���
	// String projectInfoNo = user.getProjectInfoNo();
	// //��̨��ID
	// String fkDevAccId = msg.getValue("fk_dev_acc_id");
	// //�Ӽ�̨��ID
	// String devAccId = msg.getValue("ids");
	// //��������
	// StringBuffer sb = new StringBuffer();
	// sb.append("select mp.fk_dev_acc_id,mp.plan_date,mp.plan_num,acc.dev_name,acc.dev_model, ")
	// .append("acc.self_num,acc.license_num from gms_device_maintenance_plan mp ")
	// .append("left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id where acc.bsflag='0' ")
	// .append("and fk_dev_acc_id = '").append(devAccId).append("'");
	//
	//
	// responseDTO.setValue(arg0, arg1);deviceaccMap
	// return responseDTO;
	// }
	/**
	 * ����Ŀ����ά��excel�������ݿ�
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveExcelBywx(ISrvMsg reqDTO) throws Exception {
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		String errorMessage = null;
		/**
		 * ��ȡexcel�е�����
		 */
		List<WSFile> files = mqMsg.getFiles();
		List<Map> columnList = new ArrayList<Map>();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil
						.getBywxzyExcelDataByWSFile(file);
			}
		}

		/**
		 * �Ż������ٶ� �ܳɼ���� ���豸���ֱ�Ӵ�map��ȡ
		 */
		Map<String, String> zcjStore = new HashMap<String, String>();
		String zcj = " select coding_code_id,coding_name   from comm_coding_sort_detail where coding_sort_id='5110000188' and bsflag='0' ";
		List<Map> zcjStoreList = this.pureDao.queryRecords(zcj);
		for (Map map : zcjStoreList) {
			zcjStore.put(map.get("coding_name").toString(),
					map.get("coding_code_id").toString());
		}

		Map<String, String> bjStore = new HashMap<String, String>();
		String bj = " select coding_code_id,coding_name   from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0' ";
		List<Map> bjStoreList = this.pureDao.queryRecords(zcj);
		for (Map map : bjStoreList) {
			bjStore.put(map.get("coding_name").toString(),
					map.get("coding_code_id").toString());
		}
		/**
		 * ��Ŀ�洢��
		 */
		Map<String, String> projectStore = new HashMap<String, String>();
		String new_date = "";
		String new_num = "";

		/**
		 * key :Ψһ ����ά��ʱ��+�Ա��+��Ŀ���� value:usemat_id
		 */
		Map<String, String> check = new HashMap<String, String>();
		for (int i = 0; i < dataList.size(); i++) {
			String usemat_id = "";
			boolean isAddBywxData = false;
			try {
				Map dataMap = (Map) dataList.get(i);

				// dataMap.put("bywx_date", timeChange.format(changeTime));
				Map mat = new HashMap();
				Map child = new HashMap();
				/**
				 * ��Ŀ���� ��Ŀ����Ϊ�� ���ֳ� ��Ŀ��Ϊ�� �ֳ�
				 */
				String project_name = dataMap.get("project_name") == null ? ""
						: dataMap.get("project_name").toString();

				String self_num = dataMap.get("self_num") == null ? ""
						: dataMap.get("self_num").toString();
				String project_info_id = "";
				String dev_acc_id_Sql = "";
				String real_dev_acc_id_Sql = "";
				String dev_acc_id = "";
				String fk_dev_acc_id = "";
				/**
				 * ���ֳ����ֳ�
				 */
				if ("".equals(project_name)) {
					project_info_id = "";
					dev_acc_id_Sql = "select dev_acc_id from gms_device_account d where d.self_num='"
							+ self_num + "'";
				}

				else {
					if ("".equals(projectStore.get("project_name"))
							|| null == projectStore.get("project_name")) {
						String project_info_id_sql = "select t.project_info_no from  gp_task_project t where t.bsflag='0' and t.project_name='"
								+ project_name + "' ";
						List<Map> project_list = this.jdbcDao
								.queryRecords(project_info_id_sql);
						if (null != project_list && project_list.size() > 0) {
							project_info_id = project_list.get(0)
									.get("project_info_no").toString();
						} else {
							Map<String, Object> reason = new HashMap<String, Object>();
							reason.put("happentime", new Date());
							reason.put("content", project_name + "��Ŀ������,Ĭ�ϵ�ǰ��Ŀ"
									+ ",excel�е�����" + (i + 3));
							this.jdbcDao.saveOrUpdateEntity(reason,
									"GMS_DEVICE_ZY_DRFAIL");
						}
						projectStore.put(project_name, project_info_id);
					} else {
						project_info_id = projectStore.get("project_name");
					}
					/**
					 * �Ӽ�̨��sql
					 */
					dev_acc_id_Sql = "select dev_acc_id from gms_device_account_dui d where d.self_num='"
							+ self_num
							+ "' and d.bsflag='0'  and  d.project_info_id='"
							+ project_info_id + "'";

				}
				List<Map<String, Object>> dev_acc_id_list = jdbcTemplate
						.queryForList(dev_acc_id_Sql);
				// Map devMap = jdbcDao.queryRecordBySQL(dev_acc_id_Sql);

				/**
				 * ��Դ����
				 */
				if (project_name != null && !"".equals(project_name)) {

					if (dev_acc_id_list == null || dev_acc_id_list.size() == 0
							|| dev_acc_id_list.get(0).get("dev_acc_id") == null) {
						real_dev_acc_id_Sql = "select * from gms_device_account d where d.self_num='"
								+ self_num + "' and d.bsflag='0'";
						dev_acc_id_list = jdbcTemplate
								.queryForList(real_dev_acc_id_Sql);
						try {
							fk_dev_acc_id = dev_acc_id_list.get(0)
									.get("dev_acc_id").toString();
						} catch (Exception e) {
							Map<String, Object> reason = new HashMap<String, Object>();
							reason.put("happentime", new Date());
							reason.put("content", "���ֳ��Ա��Ϊ:" + self_num
									+ "����̨���в�����" + ",excel�е�����" + (i + 3));
							this.jdbcDao.saveOrUpdateEntity(reason,
									"GMS_DEVICE_ZY_DRFAIL");
							continue;
						}
						Map<String, Object> devMap = dev_acc_id_list.get(0);

						// �Ӽ�̨����������
						// �Ӽ�̨���豸����
						dev_acc_id = UUID.randomUUID().toString()
								.replaceAll("-", "");
						// �豸����
						String dev_coding = devMap.get("dev_coding") == null ? ""
								: devMap.get("dev_coding").toString();
						// �豸����
						String dev_name = devMap.get("dev_name") == null ? ""
								: devMap.get("dev_name").toString();
						// �ʲ�״̬
						String asset_stat = devMap.get("asset_stat") == null ? ""
								: devMap.get("asset_stat").toString();
						// �豸����
						String dev_model = devMap.get("dev_model") == null ? ""
								: devMap.get("dev_model").toString();
						// ʵ���ʶ��dev_sign
						String dev_sign = devMap.get("dev_sign") == null ? ""
								: devMap.get("dev_sign").toString();
						// �豸����dev_type
						String dev_type = devMap.get("dev_type") == null ? ""
								: devMap.get("dev_type").toString();
						// ������λdev_unit
						String dev_unit = devMap.get("dev_unit") == null ? ""
								: devMap.get("dev_unit").toString();
						// �ʲ�ԭֵasset_value
						String asset_value = devMap.get("asset_value") == null ? ""
								: devMap.get("asset_value").toString();
						// �ʲ���ֵnet_value
						String net_value = devMap.get("net_value") == null ? ""
								: devMap.get("net_value").toString();
						// ����״̬tech_stat
						String tech_stat = devMap.get("tech_stat") == null ? ""
								: devMap.get("tech_stat").toString();
						// ʹ��״̬using_stat
						String using_stat = devMap.get("using_stat") == null ? ""
								: devMap.get("using_stat").toString();
						// '������λ' owning_org_id;
						String owning_org_id = devMap.get("owning_org_id") == null ? ""
								: devMap.get("owning_org_id").toString();

						// '������λ����';
						String owning_org_name = devMap.get("owning_org_name") == null ? ""
								: devMap.get("owning_org_name").toString();

						// '������λ������ϵ';
						String owning_sub_id = devMap.get("owning_sub_id") == null ? ""
								: devMap.get("owning_sub_id").toString();

						// '���ڵ�λ';
						String usage_org_id = devMap.get("usage_org_id") == null ? ""
								: devMap.get("usage_org_id").toString();

						// '���ڵ�λ����';
						String usage_org_name = devMap.get("usage_org_name") == null ? ""
								: devMap.get("usage_org_name").toString();

						// '���ڵ�λ������ϵ';
						String usage_sub_id = devMap.get("usage_sub_id") == null ? ""
								: devMap.get("usage_sub_id").toString();

						/**
						 * ������Դ̨����Ϣ
						 */
						// �ʲ����(ERP)
						String asset_coding = devMap.get("asset_coding") == null ? ""
								: devMap.get("asset_coding").toString();
						// ת�ʵ���
						String turn_num = devMap.get("turn_num") == null ? ""
								: devMap.get("turn_num").toString();
						// ��ͬ��
						String cont_num = devMap.get("cont_num") == null ? ""
								: devMap.get("cont_num").toString();
						// ��������producting_date
						String producting_date = devMap.get("producting_date") == null ? ""
								: devMap.get("producting_date").toString();
						if (!producting_date.equals("")) {
							producting_date = producting_date.substring(0, 10);
						}
						// ״̬account_stat
						String account_stat = devMap.get("account_stat") == null ? ""
								: devMap.get("account_stat").toString();
						// ����ʱ�� �͸���ʱ��
						Calendar c = Calendar.getInstance();
						Date date = c.getTime();
						SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

						String create_date = sf.format(date);
						String modifi_date = sf.format(date);

						String bsflag = "0";
						String remark = "׷������";
						String creator = user.getUserId();
						// ���պ�license_num
						String license_num = devMap.get("license_num") == null ? ""
								: devMap.get("license_num").toString();
						// ���ƺ�chassis_num
						String chassis_num = devMap.get("chassis_num") == null ? ""
								: devMap.get("chassis_num").toString();
						// ��������engine_num
						String engine_num = devMap.get("engine_num") == null ? ""
								: devMap.get("engine_num").toString();
						// �ƻ���ʼʱ�� �ƻ�����ʱ�� ʵ�ʿ�ʱ�� ʵ�ʽ���ʱ��
						String planning_in_time = "";
						String planning_out_time = "";
						String actual_in_time = "";
						String actual_out_time = "";
						String timeSql = "select t.acquire_start_time,t.acquire_end_time from gp_task_project  t where t.project_info_no='"
								+ project_info_id + "'";
						Map timeMap = this.jdbcDao.queryRecordBySQL(timeSql);
						SimpleDateFormat strongtimesf = new SimpleDateFormat(
								"yyyy-MM-dd");
						String strongtime = strongtimesf.format(new Date());
						// �����Ŀ
						String start = timeMap.get("acquire_start_time") == null ? strongtime
								: timeMap.get("acquire_start_time").toString();
						String end = timeMap.get("acquire_end_time") == null ? strongtime
								: timeMap.get("acquire_end_time").toString();
						planning_in_time = start;
						planning_out_time = end;
						actual_in_time = start;
						actual_out_time = end;
						// �볡
						String is_leaving = "1";
						// ׷����Դ����
						String addDevToAcc = "insert into gms_device_account_dui(dev_acc_id,asset_coding,turn_num,cont_num,producting_date,account_stat,create_date,modifi_date,fk_dev_acc_id ,dev_coding, dev_name, asset_stat,dev_model, "
								+ "dev_sign, dev_type,dev_unit,asset_value, net_value, tech_stat,"
								+ "  using_stat,owning_org_id,owning_org_name, owning_sub_id,usage_org_id,"
								+ " usage_org_name, usage_sub_id,bsflag, remark, creator,"
								+ "  license_num,chassis_num, engine_num ,is_leaving,planning_in_time,"
								+ "planning_out_time,actual_in_time,actual_out_time,project_info_id,self_num)  values(";
						StringBuffer str = new StringBuffer(addDevToAcc);
						str.append("'").append(dev_acc_id).append("',")
								.append("'").append(asset_coding).append("',")
								.append("'").append(turn_num).append("',")
								.append("'").append(cont_num).append("',")
								.append("to_date('").append(producting_date)
								.append("','yyyy-mm-dd'),").append("'")
								.append(account_stat).append("',")
								.append("to_date('").append(create_date)
								.append("','yyyy-mm-dd'),").append("to_date('")
								.append(modifi_date).append("','yyyy-mm-dd'),")
								.append("'").append(fk_dev_acc_id).append("',")
								.append("'").append(dev_coding).append("',")
								.append("'").append(dev_name).append("',")
								.append("'").append(asset_stat).append("',")
								.append("'").append(dev_model).append("',")
								.append("'").append(dev_sign).append("',")
								.append("'").append(dev_type).append("',")
								.append("'").append(dev_unit).append("',")
								.append("'").append(asset_value).append("',")
								.append("'").append(net_value).append("',")
								.append("'").append(tech_stat).append("',")
								.append("'").append("0110000007000000001")
								.append("',").append("'").append(owning_org_id)
								.append("',").append("'")
								.append(owning_org_name).append("',")
								.append("'").append(owning_sub_id).append("',")
								.append("'").append(usage_org_id).append("',")
								.append("'").append(usage_org_name)
								.append("',").append("'").append(usage_sub_id)
								.append("',").append("'").append(bsflag)
								.append("',").append("'").append(remark)
								.append("',").append("'").append(creator)
								.append("',").append("'").append(license_num)
								.append("',").append("'").append(chassis_num)
								.append("',").append("'").append(engine_num)
								.append("',").append("'").append(is_leaving)
								.append("',").append("").append("to_date('")
								.append(planning_in_time)
								.append("','yyyy-mm-dd'),").append("")
								.append("to_date('").append(planning_out_time)
								.append("','yyyy-mm-dd'),").append("")
								.append("to_date('").append(actual_in_time)
								.append("','yyyy-mm-dd'),").append("")
								.append("to_date('").append(actual_out_time)
								.append("','yyyy-mm-dd'),").append("'")
								.append(project_info_id).append("',")
								.append("'").append(self_num).append("')");
						jdbcTemplate.execute(str.toString());

					} else {
						try {
							dev_acc_id = dev_acc_id_list.get(0)
									.get("dev_acc_id").toString();
						} catch (Exception e) {
							Map<String, Object> reason = new HashMap<String, Object>();
							reason.put("happentime", new Date());
							reason.put("content", "�Ա������̨���в�����" + self_num
									+ ",excel�е�����" + (i + 3));
							this.jdbcDao.saveOrUpdateEntity(reason,
									"GMS_DEVICE_ZY_DRFAIL");
						}

					}
				} else {
					project_info_id = "";
					dev_acc_id = dev_acc_id_list.get(0).get("dev_acc_id")
							.toString();
				}

				/**
				 * �������ת��
				 */
				String coding_code_name = dataMap.get("coding_code_id") == null ? ""
						: dataMap.get("coding_code_id").toString();
				String coding_code_id = "";
				if (!"".equals(coding_code_name)) {
					coding_code_id = bjStore.get(coding_code_name);
				}

				/**
				 * �ܳɼ�����ת��
				 */
				String zcj_coding_name = dataMap.get("zcj_type") == null ? ""
						: dataMap.get("zcj_type").toString();
				String zcj_type = "";
				if (!"".equals(zcj_coding_name)) {
					zcj_type = zcjStore.get(zcj_coding_name);
				}

				new_date = dataMap.get("bywx_date") == null ? "" : dataMap.get(
						"bywx_date").toString();
				Date d = new Date(new_date);
				SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
				new_date = sf.format(d);
				new_num = dataMap.get("self_num") == null ? "" : dataMap.get(
						"self_num").toString();

				if (!"".equals(new_date) && !"".equals(new_num)) {
					/**
					 * ���Ψһ��KEY
					 */
					// �ۼƹ���Сʱ
					String wh = dataMap.get("work_hours") != null ? dataMap
							.get("work_hours").toString() : "0";
					// ��������
					String fd = dataMap.get("falut_desc") != null ? dataMap
							.get("falut_desc").toString() : "";
					// ����ԭ��
					String fr = dataMap.get("falut_reason") != null ? dataMap
							.get("falut_reason").toString() : "";
					// ���Ͻ���취
					String fc = dataMap.get("falut_case") != null ? dataMap
							.get("falut_case").toString() : "";
					// �ܳɼ�
					String zcjmc = zcj_type == null ? "" : zcj_type;
					// ��������
					String byjb = dataMap.get("maintenance_level") == null ? "��"
							: dataMap.get("maintenance_level").toString()
									.toUpperCase();
					if (byjb.length() >= 2) {
						byjb = byjb.substring(0, 1);
					}
					// ��Ҫ��������
					String bynr = dataMap.get("maintenance_desc") != null ? dataMap
							.get("maintenance_desc").toString() : "";
					// ���޵�λ
					String cxdw = dataMap.get("repair_unit") == null ? "��Ŀ��ά��"
							: dataMap.get("repair_unit").toString();
					// ������
					String cxr = dataMap.get("repair_men") == null ? ""
							: dataMap.get("repair_men").toString();

					// String checkKey = new_date + new_num + project_info_id;
					String sqlUseMat = "select w.usemat_id  from gms_device_zy_bywx w"
							+ "   where w.bsflag = '0'  and w.bywx_date = to_date('"
							+ new_date
							+ "', 'yyyy-mm-dd')"
							+ "    and w.dev_acc_id='"
							+ dev_acc_id
							+ "'   and w.work_hours='"
							+ wh
							+ "'  and w.maintenance_level='" + byjb + "'";
					// ��������
					if (fd.equals("")) {
						sqlUseMat += "   and w.falut_desc  is null ";

					} else {
						sqlUseMat += "   and w.falut_desc='" + fd + "'";
					}
					// ����ԭ��
					if (fr.equals("")) {
						sqlUseMat += "   and w.falut_reason  is null ";

					} else {
						sqlUseMat += "   and w.falut_reason='" + fr + "'";
					}

					// ���Ͻ���취
					if (fc.equals("")) {
						sqlUseMat += "   and w.falut_case  is null ";

					} else {
						sqlUseMat += "   and w.falut_case='" + fc + "'";
					}
					// �ܳɼ�
					if (zcjmc.equals("")) {
						sqlUseMat += "   and w.zcj_type  is null ";

					} else {
						sqlUseMat += "   and w.zcj_type='" + zcjmc + "'";
					}
					// ��������
					if (bynr.equals("")) {
						sqlUseMat += "   and w.maintenance_desc  is null ";

					} else {
						sqlUseMat += "   and w.maintenance_desc='" + bynr + "'";
					}
					// ���޵�λrepair_unit
					if (cxdw.equals("")) {
						sqlUseMat += "   and w.repair_unit  is null ";

					} else {
						sqlUseMat += "   and w.repair_unit='" + cxdw + "'";
					}
					// ������repair_men
					if (cxr.equals("")) {
						sqlUseMat += "   and w.repair_men  is null ";

					} else {
						sqlUseMat += "   and w.repair_men='" + cxr + "'";
					}
					if ("".equals(project_info_id)) {
						sqlUseMat += "   and w.project_info_id is null";
					} else {
						sqlUseMat += " and w.project_info_id='"
								+ project_info_id + "'";
					}
					List<Map<String, Object>> usematMapList = jdbcTemplate
							.queryForList(sqlUseMat);
					Map<String, Object> usematMap = null;
					if (usematMapList.size() == 0) {
						usematMap = new HashMap<String, Object>();
					} else if (usematMapList.size() > 0) {
						usematMap = usematMapList.get(0);
					}

					if (usematMap == null || usematMap.get("usemat_id") == null) {
						usemat_id = UUID.randomUUID().toString()
								.replaceAll("-", "");
						isAddBywxData = true;
					} else {
						usemat_id = usematMap.get("usemat_id").toString();
						Object wzIdObject = dataMap.get("wz_id");
						Object wzNameObject = dataMap.get("wz_name");
						if (wzIdObject == null && wzNameObject == null) {
							isAddBywxData = false;
						} else {
							isAddBywxData = false;
						}

					}

					// if (check.get(checkKey) == null) {
					// usemat_id = UUID.randomUUID().toString()
					// .replaceAll("-", "");
					if (isAddBywxData) {
						/**
						 * ����ά��������Ϣ
						 */
						// check.put(checkKey, usemat_id);
						String bywx_id = UUID.randomUUID().toString()
								.replaceAll("-", "");
						StringBuffer sql = new StringBuffer();
						sql.append("insert  into gms_device_zy_bywx(");
						sql.append("bywx_id,bywx_date,work_hours,maintenance_level,maintenance_desc,");
						sql.append("performance_desc,falut_desc,falut_case,legacy,repair_unit,");
						sql.append("repair_men,bak,falut_reason,usemat_id,zcj_type,bsflag,dev_acc_id,");
						sql.append("project_info_id,creator,create_date,org_subjection_id");
						sql.append(")");
						sql.append("values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
						/**
						 * ��������ת��
						 * 
						 */
						String performance_desc = dataMap
								.get("performance_desc") == null ? "" : dataMap
								.get("performance_desc").toString();
						if (!"".equals(performance_desc)) {
							if ("����".equals(performance_desc)) {
								performance_desc = "0";
							} else if ("����".equals(performance_desc)) {
								performance_desc = "1";
							} else if ("����".equals(performance_desc)) {
								performance_desc = "2";
							}
						}
						Date date = new Date();
						try {
							String bywxdate = dataMap.get("bywx_date") == null ? ""
									: dataMap.get("bywx_date").toString();
							Date changeTime = new Date(bywxdate);
							SimpleDateFormat timeChange = new SimpleDateFormat(
									"yyyy-MM-dd");
							String time = timeChange.format(changeTime);
							SimpleDateFormat timeChange2 = new SimpleDateFormat(
									"yyyy-MM-dd");
							date = timeChange2.parse(time);
						} catch (Exception e) {
							Map<String, Object> reason = new HashMap<String, Object>();
							reason.put("happentime", new Date());
							reason.put("content", "�������ڸ�ʽ������" + ",excel�е�����"
									+ (i + 3));
							this.jdbcDao.saveOrUpdateEntity(reason,
									"GMS_DEVICE_ZY_DRFAIL");
							continue;
						}
						String level = dataMap.get("maintenance_level") == null ? "��"
								: dataMap.get("maintenance_level").toString()
										.toUpperCase();
						if (level.length() >= 2) {
							level = level.substring(0, 1);
						}
						jdbcTemplate
								.update(sql.toString(),
										new Object[] {
												bywx_id,
												date,
												dataMap.get("work_hours"),
												level,
												dataMap.get("maintenance_desc"),
												performance_desc,
												dataMap.get("falut_desc"),
												dataMap.get("falut_case"),
												dataMap.get("legacy"),
												dataMap.get("repair_unit") == null ? "��Ŀ��ά��"
														: dataMap
																.get("repair_unit"),
												dataMap.get("repair_men"),
												dataMap.get("bak"),
												dataMap.get("falut_reason"),
												usemat_id, zcj_type, "0",
												dev_acc_id, project_info_id,
												user.getUserId(), new Date(),
												"C105006003" });

						/**
						 * ���ı�����ϸv
						 */
						this.saveBywxDetail(dataMap, jdbcTemplate, check,
								usemat_id, user, coding_code_id,
								project_info_id, i);

					} else if (!isAddBywxData) {
						this.saveBywxDetail(dataMap, jdbcTemplate, check,
								usemat_id, user, coding_code_id,
								project_info_id, i);
					}
				}
			} catch (Exception e) {
				System.out.println("��������" + e.getMessage() + e);
				// break;
				Map<String, Object> reason = new HashMap<String, Object>();
				reason.put("happentime", new Date());
				reason.put("content", ",excel�е�����" + (i + 3) + e.getMessage());
				this.jdbcDao.saveOrUpdateEntity(reason, "GMS_DEVICE_ZY_DRFAIL");
				continue;
			}
		}
		return reqMsg;
	}

	/**
	 * ����ά����ϸ
	 * 
	 * @param dataMap
	 * @param jdbcTemplate
	 * @param check
	 * @param checkKey
	 * @param user
	 * @param coding_code_id
	 * @param project_info_id
	 */
	private void saveBywxDetail(Map dataMap, JdbcTemplate jdbcTemplate,
			Map<String, String> check, String usemat_id, UserToken user,
			String coding_code_id, String project_info_id, int i) {
		System.out.println("i=" + i);
		String wz_id = dataMap.get("wz_id") == null ? "" : dataMap.get("wz_id")
				.toString();

		if (!"".equals(wz_id)) {
			String checkWzIdSql = "";
			if ("".equals(project_info_id)) {
				checkWzIdSql = "select wz_id from gms_mat_recyclemat_info r where r.wz_id='"
						+ wz_id
						+ "'  and r.wz_type='3' and r.bsflag='0'  and r.project_info_id is null";
			} else {
				checkWzIdSql = "select wz_id from gms_mat_recyclemat_info r where r.wz_id='"
						+ wz_id
						+ "'  and r.wz_type='3' and r.bsflag='0'  and r.project_info_id ='"
						+ project_info_id + "'";
			}
			List<Map<String, Object>> checkWzIdList = jdbcTemplate
					.queryForList(checkWzIdSql);
			if (checkWzIdList != null && checkWzIdList.size() > 0) {
				String wxbymat_id = UUID.randomUUID().toString()
						.replaceAll("-", "");
				StringBuffer matSQL = new StringBuffer();
				matSQL.append("insert  into  gms_device_zy_wxbymat(");
				matSQL.append("wxbymat_id,usemat_id,coding_code_id,wz_id,use_num,");
				matSQL.append("bsflag,creator,create_date");
				matSQL.append(")");
				matSQL.append("values(?,?,?,?,?,?,?,?)");
				jdbcTemplate.update(matSQL.toString(),
						new Object[] { wxbymat_id, usemat_id, coding_code_id,
								dataMap.get("wz_id"), dataMap.get("use_num"),
								"0", user.getUserId(), new Date() });
			} else {
				Map<String, Object> reason = new HashMap<String, Object>();
				reason.put("happentime", new Date());
				reason.put("content", "excel�����ʱ���Ϊ:" + wz_id
						+ "������̨���в����ڣ�������������Ƿ����" + ",excel�е�����" + (i + 3));
				this.jdbcDao.saveOrUpdateEntity(reason, "GMS_DEVICE_ZY_DRFAIL");
				String wz_name = dataMap.get("wz_name") == null ? "" : dataMap
						.get("wz_name").toString();
				// ���ʱ���δ�� �鿴���������Ƿ����
				// System.out.println("i="+wz_name+i);
				if (!"".equals(wz_name)) {
					/**
					 * ���ֳ�
					 */
					String wz_id_sql = "";
					if ("".equals(project_info_id)) {
						wz_id_sql = "   select wz_id from gms_mat_recyclemat_info r where r.wz_id in (select wz_id from gms_mat_infomation where wz_name ='"
								+ wz_name
								+ "') and r.wz_type='3' and r.bsflag='0'  and r.project_info_id is null ";
					} else {
						wz_id_sql = "   select wz_id from gms_mat_recyclemat_info r where r.wz_id in (select wz_id from gms_mat_infomation where wz_name ='"
								+ wz_name
								+ "') and r.wz_type='3' and r.bsflag='0'  and r.project_info_id='"
								+ project_info_id + "'";
					}
					List<Map<String, Object>> mMapList = jdbcTemplate
							.queryForList(wz_id_sql);
					// Map m = jdbcDao.queryRecordBySQL(wz_id_sql);
					if (mMapList != null && mMapList.size() > 0) {
						Map<String, Object> m = mMapList.get(0);
						String wzid = m.get("wz_id") == null ? "" : m.get(
								"wz_id").toString();
						if (!"".equals(wzid)) {
							String wxbymat_id = UUID.randomUUID().toString()
									.replaceAll("-", "");
							StringBuffer matSQL = new StringBuffer();
							matSQL.append("insert  into  gms_device_zy_wxbymat(");
							matSQL.append("wxbymat_id,usemat_id,coding_code_id,wz_id,use_num,");
							matSQL.append("bsflag,creator,create_date");
							matSQL.append(")");
							matSQL.append("values(?,?,?,?,?,?,?,?)");
							jdbcTemplate.update(
									matSQL.toString(),
									new Object[] { wxbymat_id, usemat_id,
											coding_code_id, wzid,
											dataMap.get("use_num"), "0",
											user.getUserId(), new Date() });
						}
					} else {
						Map<String, Object> newreason = new HashMap<String, Object>();
						newreason.put("happentime", new Date());
						newreason.put("content", "excel�����ʱ���Ϊ:" + wz_id
								+ "������̨���в����ڣ������������Ҳ������" + ",excel�е�����"
								+ (i + 3));
						this.jdbcDao.saveOrUpdateEntity(newreason,
								"GMS_DEVICE_ZY_DRFAIL");
						try {
							/**
							 * ׷����������
							 */
							String wzid = this.appendWzWhenImportBywx(wz_name,
									dataMap, user, project_info_id);
							String wxbymat_id = UUID.randomUUID().toString()
									.replaceAll("-", "");
							StringBuffer matSQL = new StringBuffer();
							matSQL.append("insert  into  gms_device_zy_wxbymat(");
							matSQL.append("wxbymat_id,usemat_id,coding_code_id,wz_id,use_num,");
							matSQL.append("bsflag,creator,create_date");
							matSQL.append(")");
							matSQL.append("values(?,?,?,?,?,?,?,?)");
							jdbcTemplate.update(
									matSQL.toString(),
									new Object[] { wxbymat_id, usemat_id,
											coding_code_id, wzid,
											dataMap.get("use_num"), "0",
											user.getUserId(), new Date() });
						} catch (Exception e) {
							Map<String, Object> entity = new HashMap<String, Object>();
							entity.put("happentime", new Date());
							entity.put("content", "excel�����ʱ���Ϊ:" + wz_id
									+ "������̨���в����ڣ�excel��������" + wz_name
									+ "���ڵ���������̨���в�����,׷�����ݳ�������" + ",excel�е�����"
									+ (i + 3));
							this.jdbcDao.saveOrUpdateEntity(entity,
									"GMS_DEVICE_ZY_DRFAIL");
						}
					}

				}
			}

		} else {
			String wz_name = dataMap.get("wz_name") == null ? "" : dataMap.get(
					"wz_name").toString();
			// ���ʱ���δ�� �鿴���������Ƿ����
			// System.out.println("i="+wz_name+i);
			if (!"".equals(wz_name)) {
				/**
				 * ���ֳ�
				 */
				String wz_id_sql = "";
				if ("".equals(project_info_id)) {
					wz_id_sql = "   select wz_id from gms_mat_recyclemat_info r where r.wz_id in (select wz_id from gms_mat_infomation where wz_name ='"
							+ wz_name
							+ "') and r.wz_type='3' and r.bsflag='0'  and r.project_info_id is null ";
				} else {
					wz_id_sql = "   select wz_id from gms_mat_recyclemat_info r where r.wz_id in (select wz_id from gms_mat_infomation where wz_name ='"
							+ wz_name
							+ "') and r.wz_type='3' and r.bsflag='0'  and r.project_info_id='"
							+ project_info_id + "'";
				}
				List<Map<String, Object>> mMapList = jdbcTemplate
						.queryForList(wz_id_sql);
				// Map m = jdbcDao.queryRecordBySQL(wz_id_sql);
				if (mMapList != null && mMapList.size() > 0) {
					Map<String, Object> m = mMapList.get(0);
					String wzid = m.get("wz_id") == null ? "" : m.get("wz_id")
							.toString();
					if (!"".equals(wzid)) {
						String wxbymat_id = UUID.randomUUID().toString()
								.replaceAll("-", "");
						StringBuffer matSQL = new StringBuffer();
						matSQL.append("insert  into  gms_device_zy_wxbymat(");
						matSQL.append("wxbymat_id,usemat_id,coding_code_id,wz_id,use_num,");
						matSQL.append("bsflag,creator,create_date");
						matSQL.append(")");
						matSQL.append("values(?,?,?,?,?,?,?,?)");
						jdbcTemplate.update(matSQL.toString(), new Object[] {
								wxbymat_id, usemat_id, coding_code_id, wzid,
								dataMap.get("use_num"), "0", user.getUserId(),
								new Date() });
					}
				} else {
					try {
						String wzid = this.appendWzWhenImportBywx(wz_name,
								dataMap, user, project_info_id);
						String wxbymat_id = UUID.randomUUID().toString()
								.replaceAll("-", "");
						StringBuffer matSQL = new StringBuffer();
						matSQL.append("insert  into  gms_device_zy_wxbymat(");
						matSQL.append("wxbymat_id,usemat_id,coding_code_id,wz_id,use_num,");
						matSQL.append("bsflag,creator,create_date");
						matSQL.append(")");
						matSQL.append("values(?,?,?,?,?,?,?,?)");
						jdbcTemplate.update(matSQL.toString(), new Object[] {
								wxbymat_id, usemat_id, coding_code_id, wzid,
								dataMap.get("use_num"), "0", user.getUserId(),
								new Date() });
					} catch (Exception e) {
						Map<String, Object> entity = new HashMap<String, Object>();
						entity.put("happentime", new Date());
						entity.put("content", "excel�����ʱ��벻����:" + "excel��������"
								+ wz_name + "���ڵ���������̨���в�����,׷�����ݳ�������"
								+ ",excel�е�����" + (i + 3));
						this.jdbcDao.saveOrUpdateEntity(entity,
								"GMS_DEVICE_ZY_DRFAIL");
					}
				}

			}
		}
	}

	/**
	 * ����ά�޵���,׷�ӵ��붪ʧ���ʣ�excel���������ƴ��ڣ�
	 * 
	 * @param wz_name
	 * @return
	 */
	private String appendWzWhenImportBywx(String wz_name, Map dataMap,
			UserToken user, String project_info_id) {
		String wz_id = "";
		wz_id = this.createWzId();
		insertIntoMatInfo(dataMap, wz_id, user, project_info_id);
		return wz_id;
	}

	private String createWzId() {
		String wz_id = "";
		String pix = "";
		JdbcTemplate jdbcTemplate = this.jdbcDao.getJdbcTemplate();
		// �������ʱ��벢������ʱ����Ƿ�Ψһ
		boolean isUnique = true;
		while (isUnique) {

			String sortNoStr = "";
			String sqlno = "select sortno from gms_device_matno where id=1";
			List<Map<String, Object>> NoMapList = jdbcTemplate
					.queryForList(sqlno);
			if (null != NoMapList && NoMapList.size() > 0) {
				sortNoStr = NoMapList.get(0).get("sortno").toString();
			} else {
				sortNoStr = "1";
			}
			// Map result = jdbcDao.queryRecordBySQL(sqlno);
			// sortNoStr = result.get("sortno").toString();
			int sortNo = Integer.parseInt(sortNoStr) + 1;
			/**
			 * ��Դ�����м䲿��
			 */
			for (int k = 0; k < (9 - (sortNoStr.length())); k++) {
				pix += "0";

			}
			wz_id = "zy" + pix + sortNoStr;
			String sql = "select count(*) as num from gms_mat_infomation  where wz_id='"
					+ wz_id + "'";
			List<Map<String, Object>> uniqueMapList = jdbcTemplate
					.queryForList(sql);
			if (Integer.parseInt(uniqueMapList.get(0).get("num").toString()) == 0) {

				String updateSql = "update gms_device_matno set sortno="
						+ sortNo + " where id=1";
				jdbcTemplate.update(updateSql);
				isUnique = false;
				sortNoStr = "";
				pix = "";
			} else {
				sortNo = sortNo + 1;
				String updateSql = "update gms_device_matno set sortno="
						+ sortNo + " where id=1";
				jdbcTemplate.update(updateSql);
				isUnique = true;
				sortNoStr = "";
				pix = "";
			}
		}
		return wz_id;
	}

	private void insertIntoMatInfo(Map dataMap, String wz_id, UserToken user,
			String project_info_id) {
		JdbcTemplate jdbcTemplate = this.jdbcDao.getJdbcTemplate();
		String sub_org_id = user.getOrgSubjectionId();
		String org_id = user.getOrgId();

		Map mat = new HashMap();
		mat.put("wz_name", dataMap.get("wz_name"));
		mat.put("wz_prickie", dataMap.get("wz_prickie"));
		mat.put("wz_price", dataMap.get("wz_price"));
		mat.put("coding_code_id", "22060201");
		mat.put("wz_code", "0000000" + wz_id);
		String wz_name = mat.get("wz_name") == null ? "" : mat.get("wz_name")
				.toString();
		String wz_prickie = mat.get("wz_prickie") == null ? "" : mat.get(
				"wz_prickie").toString();
		String wz_price = mat.get("wz_price") == null ? "0" : mat.get(
				"wz_price").toString();
		String note = "";
		String coding_code_id = mat.get("coding_code_id") == null ? "" : mat
				.get("coding_code_id").toString();
		String wz_code = mat.get("wz_code").toString();
		String creator = user.getUserId();
		Date date = new Date();
		String insertSql = "insert into GMS_MAT_INFOMATION(wz_name,wz_id,wz_code,coding_code_id,"
				+ "wz_price,wz_prickie,mat_desc,note,creator,bsflag)"
				+ "values('"
				+ wz_name
				+ "','"
				+ wz_id
				+ "','"
				+ wz_code
				+ "','"
				+ coding_code_id
				+ "','"
				+ wz_price
				+ "','"
				+ wz_prickie
				+ "','"
				+ wz_name
				+ "','"
				+ note
				+ "','"
				+ creator
				+ "','" + 0 + "')";
		jdbcTemplate.update(insertSql);
		// �ֳ��ͷ��ֳ�
		if (sub_org_id.length() <= 10) {
			sub_org_id = sub_org_id;
		} else {
			sub_org_id = sub_org_id.substring(0, 10);
		}
		if (project_info_id == null || "".equals(project_info_id)) {
			String actual_price = dataMap.get("wz_price") == null ? "0"
					: dataMap.get("wz_price").toString();
			String wz_sequence = dataMap.get("wz_sequence") == null ? ""
					: dataMap.get("wz_sequence").toString();

			String partsno = "";
			String mat_model = "";
			String price = "";
			String wz_type = "3";
			String bsflag = "0";

			String ORG_SUBJECTION_ID = user.getOrgSubjectionId();
			String CREATOR_ID = user.getUserId();
			String UPDATOR_ID = user.getUserId();
			Date CREATE_DATE = new Date();
			Date MODIFI_DATE = new Date();

			String recyclemat_info = UUID.randomUUID().toString()
					.replaceAll("-", "");
			String insertSql2 = "insert into gms_mat_recyclemat_info(recyclemat_info,"
					+ "wz_id,actual_price,wz_sequence,partsno,"
					+ "mat_model,price,wz_type,BSFLAG,org_id,"
					+ "ORG_SUBJECTION_ID,CREATOR,"
					+ "UPDATOR,stock_num)"
					+ "values('"
					+ recyclemat_info
					+ "','"
					+ wz_id
					+ "',"
					+ actual_price
					+ ",'"
					+ wz_sequence
					+ "','"
					+ partsno
					+ "','"
					+ mat_model
					+ "','"
					+ price
					+ "','"
					+ wz_type
					+ "','"
					+ 0
					+ "','"
					+ user.getOrgId()
					+ "','"
					+ ORG_SUBJECTION_ID
					+ "','"
					+ CREATOR_ID

					+ "','" + UPDATOR_ID

					+ "','0')";
			jdbcTemplate.execute(insertSql2);

		} else if (project_info_id != null && !"".equals(project_info_id)) {
			String actual_price = dataMap.get("wz_price") == null ? "0"
					: dataMap.get("wz_price").toString();
			String wz_sequence = dataMap.get("wz_sequence") == null ? ""
					: dataMap.get("wz_sequence").toString();
			String partsno = "";
			String mat_model = "";
			String price = "";
			String wz_type = "3";
			String bsflag = "0";

			String ORG_SUBJECTION_ID = user.getOrgSubjectionId();
			String CREATOR_ID = user.getUserId();
			String UPDATOR_ID = user.getUserId();
			Date CREATE_DATE = new Date();
			Date MODIFI_DATE = new Date();
			String recyclemat_info = UUID.randomUUID().toString()
					.replaceAll("-", "");
			String insertSql3 = "insert into gms_mat_recyclemat_info(recyclemat_info,"
					+ "wz_id,actual_price,wz_sequence,partsno,"
					+ "mat_model,price,wz_type,PROJECT_INFO_ID,BSFLAG,org_id,"
					+ "ORG_SUBJECTION_ID,CREATOR,"
					+ "UPDATOR,stock_num)"
					+ "values('"
					+ recyclemat_info
					+ "','"
					+ wz_id
					+ "',"
					+ actual_price
					+ ",'"
					+ wz_sequence
					+ "','"
					+ partsno
					+ "','"
					+ mat_model
					+ "','"
					+ price
					+ "','"
					+ wz_type
					+ "','"
					+ project_info_id
					+ "','"
					+ 0
					+ "','"
					+ org_id
					+ "','"
					+ ORG_SUBJECTION_ID
					+ "','" + CREATOR_ID + "','"

					+ UPDATOR_ID

					+ "','0')";
			jdbcTemplate.execute(insertSql3);

		}
	}

	/**
	 * ��ѯ�豸��Ϣ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getdeviceInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_id = msg.getValue("wz_id");
		String querysgllSql = "select t.dev_acc_id,t.dev_name,t.dev_model,t.self_num,t.dev_sign,t.license_num,t.asset_coding from gms_device_account t where t.dev_acc_id in ("
				+ wz_id + ") ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * NEWMETHOD ���������豸�������뵥
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveXZTJInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// 1.��Ż�����Ϣ
		Map<String, Object> mainMap = new HashMap<String, Object>();
		String device_mixInfo_id = msg.getValue("device_mixInfo_id");
		// �ж��Ƿ������˵������뵥�ţ����û���ɣ���ô������
		String mixinfo_no = msg.getValue("mixinfo_no");
		String flag = msg.getValue("flag");
		// ����������
		String mixinfo_name = msg.getValue("mixinfo_name");
		// ת�뵥λ
		String in_org_id = msg.getValue("in_org_id");
		// ת����λ
		String out_org_id = msg.getValue("out_org_id");
		// ��ĿID
		String project_info_id = msg.getValue("inProjectInfoNo");
		// ������
		String print_emp_id = user.getUserId();
		// �������ڳ�������
		String create_date = msg.getValue("apply_date");

		if ("".equals(mixinfo_no)) {
			mixinfo_no = DevUtil.getDeviceXzAppNo();
		}
		String mixInfoID = "";
		if (device_mixInfo_id.length() >= 32) {
			mixInfoID = device_mixInfo_id;
			mainMap.put("device_mixInfo_id", device_mixInfo_id);
			// ����������
			mainMap.put("MIXINFO_NAME", mixinfo_name);
			// ��ĿID
			mainMap.put("PROJECT_INFO_NO", project_info_id);
			// ת�뵥λ
			mainMap.put("IN_ORG_ID", in_org_id);
			// ת����λ
			mainMap.put("OUT_ORG_ID", out_org_id);
			mainMap.put("BSFLAG", "0");
			mainMap.put("MIXFORM_TYPE", "6");
			mainMap.put("MIX_USER_ID", user.getUserId());
			if (flag != null) {
				if (user.getOrgSubjectionId().contains("C105029")) {
					mainMap.put("STATE", "1");
				} else {
					mainMap.put("STATE", "2");
				}

			} else {
				mainMap.put("STATE", "0");
			}
			// ����ʱ��
			mainMap.put("CREATE_DATE", create_date);
			mainMap.put("CREATOR_ID", user.getUserId());
			mainMap.put("ORG_ID", user.getOrgId());
			mainMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			mainMap.put("PRINT_EMP_ID", print_emp_id);
			Serializable s = jdbcDao.saveOrUpdateEntity(mainMap,
					"GMS_DEVICE_MIXINFO_FORM");
			mixInfoID = s.toString();
		} else {
			// ����������
			mainMap.put("MIXINFO_NO", mixinfo_no);
			// ����������
			mainMap.put("MIXINFO_NAME", mixinfo_name);
			// ��ĿID
			mainMap.put("PROJECT_INFO_NO", project_info_id);
			// ת�뵥λ
			mainMap.put("IN_ORG_ID", in_org_id);
			// ת����λ
			mainMap.put("OUT_ORG_ID", out_org_id);
			mainMap.put("BSFLAG", "0");
			mainMap.put("MIXFORM_TYPE", "6");
			mainMap.put("MIX_USER_ID", user.getUserId());
			// ����ʱ��
			mainMap.put("CREATE_DATE", create_date);
			mainMap.put("CREATOR_ID", user.getUserId());
			mainMap.put("ORG_ID", user.getOrgId());
			if (flag != null) {
				if (user.getOrgSubjectionId().contains("C105029")) {
					mainMap.put("STATE", "1");
				} else {
					mainMap.put("STATE", "2");
				}

			} else {
				mainMap.put("STATE", "0");
			}
			mainMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			mainMap.put("PRINT_EMP_ID", print_emp_id);
			Serializable id = jdbcDao.saveOrUpdateEntity(mainMap,
					"GMS_DEVICE_MIXINFO_FORM");
			mixInfoID = id.toString();
		}
		// ����̨�ʱ��е��ύ��ʶ
		String updateSaveFlagSql = "update gms_device_account t set t.saveflag='0' where t.dev_acc_id in (select d.dev_acc_id from GMS_DEVICE_APPMIX_DETAIL d where d.device_mix_subid='"
				+ mixInfoID + "')";
		jdbcDao.executeUpdate(updateSaveFlagSql);
		String deleteSql = "delete from GMS_DEVICE_APPMIX_DETAIL t where t.device_mix_subid='"
				+ mixInfoID + "'";
		jdbcDao.executeUpdate(deleteSql);

		// ѡ�е�����
		int count = Integer.parseInt(msg.getValue("count"));
		System.out.println(mixInfoID + "-----");
		// �洢
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			String dev_acc_id = msg.getValue("dev_acc_id" + keyid);
			// �����豸̨�����豸ʹ��״̬��Ϊ���� ��������״̬��ʶ����Ϊ0
			String updateSql = " update gms_device_account t  set t.saveflag='1' where t.dev_acc_id='"
					+ dev_acc_id + "'";
			jdbcDao.executeUpdate(updateSql);
			String plan_start_date = msg.getValue("plan_start_date" + keyid);
			String plan_end_date = msg.getValue("plan_end_date" + keyid);
			dataMap.put("DEV_ACC_ID", dev_acc_id);
			dataMap.put("DEVICE_MIX_SUBID", mixInfoID);
			dataMap.put("DEV_PLAN_START_DATE", plan_start_date);
			dataMap.put("DEV_PLAN_END_DATE", plan_end_date);
			jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_APPMIX_DETAIL");
		}
		// ������ύ����
		if (flag != null) {
			if (user.getOrgSubjectionId().contains("C105029")) {
				String sql2 = "update gms_device_account t set t.using_stat='0110000007000000001' , t.ifunused='0' where t.dev_acc_id in( select d.dev_acc_id  from GMS_DEVICE_APPMIX_DETAIL d  where d.device_mix_subid='"
						+ mixInfoID + "')";
				jdbcDao.executeUpdate(sql2);
			}

		}

		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("device_mixInfo_id", mixInfoID);
		return responseDTO;
	}

	/**
	 * ��ѯ�����豸����������Ϣ��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getXzDeviceInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String devrecId = msg.getValue("devrecId");
		String querySql = "";
		querySql += " select f.device_mixinfo_id,f.mixinfo_no,f.mixinfo_name, inorg.org_abbreviation as inorgname,outorg.org_abbreviation as outorgname,f.create_date,p.project_name,(case when f.state ='0' then 'δ�ύ' when  f.state='1' then '���ύ' end) as state,puser.user_name from GMS_DEVICE_MIXINFO_FORM f ";
		querySql += " left join (comm_org_subjection sub left join comm_org_information inorg on sub.org_id=inorg.org_id )  on f.in_org_id = sub.org_subjection_id ";
		querySql += " left join (comm_org_subjection sub left join comm_org_information outorg on sub.org_id=outorg.org_id )  on f.out_org_id = sub.org_subjection_id ";
		querySql += " left join gp_task_project p on p.project_info_no=f.project_info_no";
		querySql += " left join p_auth_user puser on puser.user_id=f.creator_id ";
		querySql += " where f.mixform_type='6' and f.device_mixinfo_id='"
				+ devrecId + "'";
		Map repairInfoMap = this.jdbcDao.queryRecordBySQL(querySql);
		responseDTO.setValue("deviceaccMap", repairInfoMap);
		return responseDTO;
	}

	/**
	 * ��ѯ�豸��Ϣ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMixDeviceInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_id = msg.getValue("mixId");
		String querysgllSql = "select f.creator_id,u.user_name,f.mixinfo_no,f.mixinfo_name,f.create_date,f.in_org_id,inorg.org_abbreviation as inorgname,f.out_org_id,outorg.org_abbreviation as outorgname,p.project_name,f.project_info_no from GMS_DEVICE_MIXINFO_FORM f ";
		querysgllSql += " left join (comm_org_subjection sub left join comm_org_information inorg on sub.org_id=inorg.org_id )  on f.in_org_id = sub.org_subjection_id ";
		querysgllSql += " left join (comm_org_subjection sub left join comm_org_information outorg on sub.org_id=outorg.org_id )  on f.out_org_id = sub.org_subjection_id ";
		querysgllSql += " left join p_auth_user u on u.user_id=f.creator_id ";

		querysgllSql += " left join gp_task_project p on p.project_info_no=f.project_info_no";
		querysgllSql += " where f.device_mixinfo_id='" + wz_id + "'";
		Map map = new HashMap();
		map = jdbcDao.queryRecordBySQL(querysgllSql);
		List<Map> list = new ArrayList<Map>();
		String listSql = " select t.dev_name,t.dev_acc_id,t.dev_model,t.self_num,t.dev_sign,d.dev_plan_start_date";
		listSql += " ,d.dev_plan_end_date from GMS_DEVICE_APPMIX_DETAIL d left join gms_device_account t on t.dev_acc_id=d.dev_acc_id  where d.device_mix_subid='"
				+ wz_id + "'";
		list = jdbcDao.queryRecords(listSql);
		responseDTO.setValue("datas", list);
		responseDTO.setValue("devMap", map);
		return responseDTO;
	}

	/**
	 * �����豸������ϸ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevRecDetailInfo(ISrvMsg reqDTO) throws Exception {
		String device_appmix_id = reqDTO.getValue("devrecId");
		String mixId = reqDTO.getValue("mixId");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer()
				.append("select  t.self_num, t.dev_name,t.dev_model,t.dev_sign,t.dev_model,t.dev_coding,t.license_num,d.dev_plan_start_date,d.dev_plan_end_date,t.dev_position,d.actual_in_time,")
				.append("case d.state when '1' then '�ѽ���' else 'δ����' end as state_desc  from gms_device_appmix_detail  d ")
				.append("left join gms_device_account t on t.dev_acc_id=d.dev_acc_id where d.dev_acc_id='"
						+ device_appmix_id
						+ "' and d.device_mix_subid='"
						+ mixId + "' ");
		Map devicerecMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (devicerecMap != null) {
			responseMsg.setValue("devicerecMap", devicerecMap);
		}

		return responseMsg;
	}

	/**
	 * �����豸������ϸ�ύ����
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg saveDevXZReceive(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String mixId = msg.getValue("mixId");
		String id = msg.getValue("dev_id");
		// ʡ��
		String province_in = msg.getValue("province_in");
		// �ص�
		String dev_position_in = msg.getValue("dev_position_in");
		String postion = province_in + dev_position_in;
		// ����ʱ��
		String actual_start_date = msg.getValue("actual_start_date");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");

		// �޸Ĵ�̨���е�״̬
		String updateAccountSql = " update gms_device_account t set  t.ifunused='0' ,t.usage_org_id='"
				+ user.getOrgId()
				+ "',t.usage_sub_id='"
				+ user.getOrgSubjectionId()
				+ "',t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "',t.dev_position='"
				+ postion
				+ "' where t.dev_acc_id in(" + id + ") ";
		jdbcDao.executeUpdate(updateAccountSql);
		// �޸ĵ��������ϸ��״̬��Ϊ1��ʾ�ѽ���
		String updateDetailSql = " update gms_device_appmix_detail d set d.state='1' ,d.actual_in_time=to_date('"
				+ actual_start_date
				+ "','yyyy-mm-dd') where d.device_mix_subid='"
				+ mixId
				+ "' and  d.dev_acc_id in (" + id + ")";
		jdbcDao.executeUpdate(updateDetailSql);
		// ���µ���������״̬gms_device_mixinfo_form
		String mixInfoSql = "";
		String selectDetailSql = " select count(*) as result from gms_device_appmix_detail d  where d.device_mix_subid='"
				+ mixId + "' ";
		Map deMap = jdbcDao.queryRecordBySQL(selectDetailSql);
		String selectDetailStateSql = " select count(*) as result from gms_device_appmix_detail d  where d.device_mix_subid='"
				+ mixId + "'  and d.state='1'";
		Map deSMap = jdbcDao.queryRecordBySQL(selectDetailStateSql);
		if (deMap != null && deSMap != null) {
			if (deMap.get("result").toString()
					.equals(deSMap.get("result").toString())) {
				mixInfoSql = " update gms_device_mixinfo_form f set f.opr_state='9' where f.DEVICE_MIXINFO_ID='"
						+ mixId + "'";
			} else {
				mixInfoSql = " update gms_device_mixinfo_form f set f.opr_state='1' where f.DEVICE_MIXINFO_ID='"
						+ mixId + "'";

			}

		} else {
			mixInfoSql = " update gms_device_mixinfo_form f set f.opr_state='1' where f.DEVICE_MIXINFO_ID='"
					+ mixId + "'";

		}
		DeviceMCSBean devbean = new DeviceMCSBean();
		jdbcDao.executeUpdate(mixInfoSql);
		//
		// //���豸���뵽�Ӽ�̨��
		String devaccId = id.replaceAll("��", " ");
		String[] devs = devaccId.split(",");
		for (int i = 0; i < devs.length; i++) {
			String regexp = "\'";
			String devId = devs[i].replaceAll(regexp, "");
			Map<String, Object> Map_dui = devbean.queryDevAccInfo(devId);
			String selectStateSql = "select d.dev_plan_start_date,d.dev_plan_end_date,d.actual_in_time,s.org_id,f.out_org_id from gms_device_appmix_detail d  left join gms_device_mixinfo_form f on f.device_mixinfo_id=d.device_mix_subid left join comm_org_subjection s on s.org_subjection_id=f.in_org_id ";
			selectStateSql += " where d.device_mix_subid='" + mixId
					+ "' and d.dev_acc_id=" + devs[i] + "";
			Map dcSMap = jdbcDao.queryRecordBySQL(selectStateSql);
			String accountDuiSql = "select count(*) as result from gms_device_account_dui dui where dui.fk_dev_acc_id="
					+ devs[i]
					+ " and dui.project_info_id='"
					+ user.getProjectInfoNo() + "' ";
			Map dcduiSMap = jdbcDao.queryRecordBySQL(accountDuiSql);
			if (dcduiSMap.get("result").toString().equals("0")) {
				String searchid = UUID.randomUUID().toString()
						.replaceAll("-", "");
				Map_dui.put("search_id", searchid);
				Map_dui.remove("dev_acc_id");
				Map_dui.put("fk_dev_acc_id", devId);
				Map_dui.put("project_info_id", user.getProjectInfoNo());
				Map_dui.put("planning_in_time",
						dcSMap.get("dev_plan_start_date"));
				Map_dui.put("planning_out_time",
						dcSMap.get("dev_plan_end_date"));
				Map_dui.put("actual_in_time", dcSMap.get("actual_in_time"));
				Map_dui.put("using_stat", "0110000007000000001");
				Map_dui.put("in_org_id", dcSMap.get("org_id"));
				Map_dui.put("out_org_id", dcSMap.get("out_org_id"));
				Map_dui.put("create_date", currentdate);
				Map_dui.put("modifi_date", currentdate);
				Serializable curid = jdbcDao.saveOrUpdateEntity(Map_dui,
						"gms_device_account_dui");
			}
		}

		// ��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}

	/**
	 * ��ȡ��Ҫ�豸�������ͳ�Ʒ�������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllDevChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��̽��
		String wutanorg = isrvmsg.getValue("wutanorg");
		String[] devices = { "1-��������-��-D001", "2-�ɿ���Դ-̨-D002",
				"3-��װ���-̨-D003001", "4-��̧�����-̨-D003002", "5-�����豸-��-D004",
				"7-�첨��-��-D005" };
		String sql = "select parent_id," // ��ʾID
				+ "device_name," // �豸����
				+ "unit," // ��λ
				+ "nvl(total_num_in,0) total_num_in," // ����(����)
				+ "nvl(total_num_out,0) total_num_out," // ����(����)
				+ "nvl(user_num_in,0) user_num_in," // ��������(����)
				+ "nvl(user_num_out,0) user_num_out," // ��������(����)
				+ "nvl(total_num_in - user_num_in - unnus_num_in - unndus_num_in,0) unsued_in," // ��������(����)
				+ "nvl(total_num_out - user_num_out - unnus_num_out - unndusd_out,0) unsued_out," // ��������(����)
				+ "nvl(unnus_num_in + unndus_num_in,0) usds_num_in," // ����/��������(����)
				+ "nvl(unnus_num_out + unndusd_out,0) usds_num_out," // ����/��������(����)
				+ "nvl(repairing_num_in,0) repairing_num_in," // ����������(����)
				+ "nvl(repairing_num_out,0) repairing_num_out " // ����������(����)
				+ "from ( ";

		for (int i = 0; i < devices.length; i++) {
			String[] device = devices[i].split("-");
			sql += "select '"
					+ device[0]
					+ "' parent_id,'"
					+ device[1]
					+ "' device_name,'"
					+ device[2]
					+ "' unit,"
					+ "sum(case when colname='����' and country='����' then zs else 0 end) total_num_in,"
					+ "sum(case when colname='����' and country='����' then zs else 0 end) total_num_out,"
					+ "sum(case when colname='����' and country='����' then zs else 0 end) user_num_in,"
					+ "sum(case when colname='����' and country='����' then zs else 0 end) user_num_out,"
					+ "sum(case when colname='����' and country='����' then zs else 0 end) unnus_num_in,"
					+ "sum(case when colname='����' and country='����' then zs else 0 end) unnus_num_out,"
					+ "sum(case when colname='����' and country='����' then zs else 0 end) unndus_num_in,"
					+ "sum(case when colname='����' and country='����' then zs else 0 end) unndusd_out,"
					+ "sum(case when colname='������' and country='����' then zs else 0 end) repairing_num_in,"
					+ "sum(case when colname='������' and country='����' then zs else 0 end) repairing_num_out "
					+ "from( "
					+ "select '����' as COLNAME,nvl(sum(sum_num), 0) as zs,country from gms_device_dailyhistory where device_type in "
					+ "(select device_code from dms_device_tree where bsflag = '0' and device_code is not null and dev_tree_id like '"
					+ device[3]
					+ "%' and his_date = to_date(to_char(sysdate - 1, 'yyyy/mm/dd'),'yyyy/mm/dd')) and org_subjection_id like '"
					+ wutanorg
					+ "%' group by country "
					+ "union "
					+ "select '����' as COLNAME,nvl(sum(use_num), 0) as zs,country from gms_device_dailyhistory where device_type in "
					+ "(select device_code from dms_device_tree where bsflag = '0' and device_code is not null and dev_tree_id like '"
					+ device[3]
					+ "%' and his_date = to_date(to_char(sysdate - 1, 'yyyy/mm/dd'),'yyyy/mm/dd')) and org_subjection_id like '"
					+ wutanorg
					+ "%' group by country "
					+ "union "
					+ "select '����' as COLNAME,nvl(sum(repairing_num), 0) as zs,country from gms_device_dailyhistory where device_type in "
					+ "(select device_code from dms_device_tree where bsflag = '0' and device_code is not null and dev_tree_id like '"
					+ device[3]
					+ "%' and his_date = to_date(to_char(sysdate - 1, 'yyyy/mm/dd'),'yyyy/mm/dd')) and org_subjection_id like '"
					+ wutanorg
					+ "%' group by country "
					+ "union "
					+ "select '����' as COLNAME,nvl(sum(wait_repair_num), 0) as zs,country from gms_device_dailyhistory where device_type in "
					+ "(select device_code from dms_device_tree where bsflag = '0' and device_code is not null and dev_tree_id like '"
					+ device[3]
					+ "%' and his_date = to_date(to_char(sysdate - 1, 'yyyy/mm/dd'),'yyyy/mm/dd')) and org_subjection_id like '"
					+ wutanorg
					+ "%' group by country "
					+ "union "
					+ "select '������' as COLNAME,nvl(sum(wait_scrap_num), 0) as zs,country from gms_device_dailyhistory where device_type in "
					+ "(select device_code from dms_device_tree where bsflag = '0' and device_code is not null and dev_tree_id like '"
					+ device[3]
					+ "%' and his_date = to_date(to_char(sysdate - 1, 'yyyy/mm/dd'),'yyyy/mm/dd')) and org_subjection_id like '"
					+ wutanorg + "%' group by country )tmp ";

			if (i == devices.length - 1) {
				sql += "";
			} else {
				sql += "union ";
			}
		}
		sql += " ) ";
		System.out.println("sql == " + sql);
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ��Դͳ��
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getKkzyTJ(ISrvMsg isrvmsg) throws Exception {
		// �������� B,C,D,
		String byjb = isrvmsg.getValue("byjb");
		String byjbSql = "";
		if (null != byjb && !"".equals(byjb) && !"null".equals(byjb)) {
			byjb = byjb.substring(0, byjb.lastIndexOf(","));
			String str[] = byjb.split(",");
			for (int i = 0; i < str.length; i++) {
				byjbSql += "'" + str[i] + "'" + ",";

			}
			byjbSql = byjbSql.substring(0, byjbSql.lastIndexOf(","));
		}
		// ����ID B,C,D,
		String wz_id = isrvmsg.getValue("wz_id");
		String wz_idSql = "";
		if (null != wz_id && !"".equals(wz_id) && !"null".equals(wz_id)) {
			wz_id = wz_id.substring(0, wz_id.lastIndexOf(","));
			String str[] = wz_id.split(",");
			for (int i = 0; i < str.length; i++) {
				wz_idSql += "'" + str[i] + "'" + ",";
			}
			wz_idSql = wz_idSql.substring(0, wz_idSql.lastIndexOf(","));
		}
		String orgSubjectionId = isrvmsg.getUserToken().getOrgSubjectionId();
		// �Ա�ż��ϣ�
		String self_num = isrvmsg.getValue("self_num");
		// ����ά�޿�ʼʱ��
		String bywx_date_begin = isrvmsg.getValue("bywx_date_begin");
		if (null == bywx_date_begin || "".equals(bywx_date_begin)) {
			bywx_date_begin = new SimpleDateFormat("yyyy").format(new Date())
					+ "-01-01";
		}
		// ����ά�޿�ʼʱ��
		String bywx_date_end = isrvmsg.getValue("bywx_date_end");
		if (null == bywx_date_end || "".equals(bywx_date_end)) {
			bywx_date_end = new SimpleDateFormat("yyyy-MM-dd")
					.format(new Date());
		}

		// ��ĿID���ϣ�
		String project_info_id = isrvmsg.getValue("project_info_id");
		// �������� ģ����ѯ
		String wz_name = isrvmsg.getValue("wz_name");
		if (null != wz_name && !"".equals(wz_name)) {
			wz_name = java.net.URLDecoder.decode(wz_name, "utf-8");
		}
		// �ۼƹ���Сʱ��ֹʱ��
		String work_hours_begin = isrvmsg.getValue("work_hours_begin");
		String work_hours_end = isrvmsg.getValue("work_hours_end");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String self_nums = "";
		if (null != self_num && !"".equals(self_num)) {
			if (self_num.indexOf(",") > 0) {
				String[] snum = self_num.split(",");
				for (int i = 0; i < snum.length; i++) {
					self_nums += "'" + snum[i] + "'" + ",";
				}
				if (null != self_nums && !"".equals(self_nums)) {
					self_nums = self_nums.substring(0,
							self_nums.lastIndexOf(","));
				}
			} else {
				List<Map> list = jdbcDao
						.queryRecords("select self_num from gms_device_account  where  dev_type  like 'S06230101%'  and  bsflag='0' and  dev_type  like 'S06230101%'  and  self_num  like '%"
								+ self_num + "%'");
				if (null == list) {
					self_nums = "";
				} else {
					for (Map map : list) {
						self_nums += "'" + map.get("self_num").toString() + "'"
								+ ",";
					}
					if (null != self_nums && !"".equals(self_nums)) {
						self_nums = self_nums.substring(0,
								self_nums.lastIndexOf(","));
					}
				}
			}

		}

		String zcjType = isrvmsg.getValue("zcjType");
		String project_info_ids = "";
		if (null != project_info_id && !"".equals(project_info_id)) {
			String[] pid = project_info_id.split(",");
			for (int i = 0; i < pid.length; i++) {
				project_info_ids += "'" + pid[i] + "'" + ",";
			}
			if (null != project_info_ids && !"".equals(project_info_ids)) {
				project_info_ids = project_info_ids.substring(0,
						project_info_ids.lastIndexOf(","));
			}
		}
		StringBuilder sql = new StringBuilder(
				"  select  nvl(price,0) as price ,nvl(num,0) as num   ,zytype from (select sum (m.use_num*r.actual_price) as price , sum(m.use_num) as num  ,'fxcsb' as zytype"
						+ " from gms_device_zy_bywx t"
						+ " left join gms_device_zy_wxbymat m"
						+ "  on t.usemat_id = m.usemat_id"
						+ "  left join gms_mat_recyclemat_info  r "
						+ "   on r.wz_id=m.wz_id"
						+ "   where t.project_info_id is null");
		sql.append("    and r.wz_type='3'   and r.bsflag='0'  and  r.project_info_id  is null   and t.bsflag='0' ");
		if (null != self_nums && !"".equals(self_nums) && !"".equals(self_num)) {
			String self_num_sql = "   and t.dev_acc_id  in (select dev_acc_id from  gms_device_account   where self_num  in ("
					+ self_nums + ") )";
			sql.append(self_num_sql);
		} else if ("".equals(self_nums) && !"".equals(self_num)
				&& null != self_num) {
			String self_num_sql = "   and  1!=1";
			sql.append(self_num_sql);
		}
		if (null != bywx_date_begin && !"".equals(bywx_date_begin)) {
			String begin = "    and t.bywx_date>=to_date('" + bywx_date_begin
					+ "','yyyy-mm-dd')";
			sql.append(begin);
		}
		if (null != bywx_date_end && !"".equals(bywx_date_end)) {
			String end = "    and t.bywx_date<=to_date('" + bywx_date_end
					+ "','yyyy-mm-dd')";
			sql.append(end);
		}
		if (null != work_hours_begin && !"".equals(work_hours_begin)) {
			int num = Integer.parseInt(work_hours_begin);
			String begin = " and t.work_hours is not null ";
			sql.append(begin);
		}
		if (null != work_hours_end && !"".equals(work_hours_end)) {
			int num = Integer.parseInt(work_hours_end);
			String end = "  and to_number(nvl(t.work_hours,0))<=" + num;
			sql.append(end);
		}
		// if (null != wz_name && !"".equals(wz_name)) {
		// String wz_name_sql =
		// "    and m.wz_id  in (  select wz_id  from  gms_mat_recyclemat_info f where  f.wz_type='3'  and f.bsflag='0'  and  f.wz_id in (  select wz_id from  gms_mat_infomation  where wz_name  like '%"
		// + wz_name + "%'))";
		// sql.append(wz_name_sql);
		// }
		if (null != zcjType && !"".equals(zcjType)) {
			String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType + "')";
			sql.append(zcj_typeSql);
		}
		if (!"".equals(wz_id) && null != wz_id) {
			String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
			sql.append(wz_id_sql);
		}
		if (!"".equals(byjb) && null != byjb) {
			String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in (" + byjbSql
					+ ")";
			sql.append(by_jb_sql);
		}
		sql.append(" union all"
				+ "   select sum (m.use_num*r.actual_price) as price ,sum (m.use_num) as num  ,'xcsb' as zytype"
				+ " from gms_device_zy_bywx t"
				+ " left join gms_device_zy_wxbymat m"
				+ "  on t.usemat_id = m.usemat_id"
				+ "   left join gms_mat_recyclemat_info  r "
				+ "  on r.wz_id=m.wz_id"
				+ "  where 1=1  and r.project_info_id=t.project_info_id  ");

		if (null != project_info_ids && !"".equals(project_info_ids)) {
			String project_info_id_sql = "  and t.project_info_id in ("
					+ project_info_ids + ")";
			sql.append(project_info_id_sql);

		} else {
			String project_info_id_sql = "    and t.project_info_id is not null  ";
			sql.append(project_info_id_sql);
		}
		sql.append("    and r.wz_type='3'   and r.bsflag=0    and t.bsflag='0'  and r.project_info_id  is not null ");

		if (null != self_nums && !"".equals(self_nums) && !"".equals(self_num)) {
			String self_num_sql = "   and t.dev_acc_id  in (select dev_acc_id from  gms_device_account_dui   where self_num  in ("
					+ self_nums + ") )";
			sql.append(self_num_sql);
		} else if ("".equals(self_nums) && !"".equals(self_num)
				&& null != self_num) {
			String self_num_sql = "   and  1!=1";
			sql.append(self_num_sql);
		}

		if (null != bywx_date_begin && !"".equals(bywx_date_begin)) {
			String begin = "    and t.bywx_date>=to_date('" + bywx_date_begin
					+ "','yyyy-mm-dd')";
			sql.append(begin);
		}
		if (null != bywx_date_end && !"".equals(bywx_date_end)) {
			String end = "    and t.bywx_date<=to_date('" + bywx_date_end
					+ "','yyyy-mm-dd')";
			sql.append(end);
		}
		if (null != work_hours_begin && !"".equals(work_hours_begin)) {
			int num = Integer.parseInt(work_hours_begin);
			String begin = " and t.work_hours is not null ";
			sql.append(begin);
		}
		if (null != work_hours_end && !"".equals(work_hours_end)) {
			int num = Integer.parseInt(work_hours_end);
			String end = "  and to_number(t.work_hours)<=" + num;
			sql.append(end);
		}
		// if (null != wz_name && !"".equals(wz_name)) {
		// String wz_name_sql =
		// "    and m.wz_id  in (  select wz_id  from  gms_mat_recyclemat_info f where  f.wz_type='3'  and f.bsflag='0'  and  f.wz_id in (  select wz_id from  gms_mat_infomation  where wz_name  like '%"
		// + wz_name + "%'))";
		// sql.append(wz_name_sql);
		// }
		if (null != zcjType && !"".equals(zcjType)) {
			String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType + "')";
			sql.append(zcj_typeSql);
		}

		if (!"".equals(wz_id) && null != wz_id) {
			String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
			sql.append(wz_id_sql);
		}
		if (!"".equals(byjb) && null != byjb) {
			String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in (" + byjbSql
					+ ")";
			sql.append(by_jb_sql);
		}

		sql.append(") aa ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());

		Map showMap = new HashMap();
		showMap.put("xcsb", "�ֳ���Դ(Ԫ)");
		showMap.put("fxcsb", "���ֳ���Դ(Ԫ)");

		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		for (int i = 0; i < list.size(); i++) {
			Element set = root.addElement("set");
			Map map = list.get(i);
			String key = map.get("zytype").toString();
			String label = showMap.get(key).toString();
			set.addAttribute("label", label);
			String value = map.get("price").toString();
			set.addAttribute("value", value);
			if ("".equals(self_num)) {
				self_num = "null";
			}
			if ("".equals(project_info_id)) {
				project_info_id = "null";
			}
			if ("".equals(bywx_date_begin)) {
				bywx_date_begin = "null";
			}
			if ("".equals(bywx_date_end)) {
				bywx_date_end = "null";
			}
			if ("".equals(work_hours_begin)) {
				work_hours_begin = "null";
			}
			if ("".equals(work_hours_end)) {
				work_hours_end = "null";
			}
			if ("".equals(wz_name)) {
				wz_name = "null";
			}
			if ("".equals(zcjType)) {
				zcjType = "null";
			}
			if ("".equals(byjb)) {
				byjb = "null";
			}
			if ("".equals(wz_id)) {
				wz_id = "null";
			}
			String args = key + "~" + self_num + "~" + project_info_id + "~"
					+ bywx_date_begin + "~" + bywx_date_end + "~"
					+ work_hours_begin + "~" + work_hours_end + "~" + wz_name
					+ "~" + zcjType + "~" + byjb + "~" + wz_id;
			set.addAttribute("link", "JavaScript:popProjRepaCostList('" + args
					+ "')");
		}
		String sql1 = "select  sum (price) as  price ,sum(num) as num from   ("
				+ sql.toString() + ")  bb";
		List tjList = jdbcDao.queryRecords(sql1);
		responseDTO.setValue("Str", document.asXML());
		responseDTO.setValue("list", tjList);
		return responseDTO;
	}

	/**
	 * ��Դ��Ŀͳ��
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getKkzyDevTJ(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String sql = "select count(*) as num, 'fxczy'  as dev_type    "
				+ "     from gms_device_account t     "
				+ "      where t.dev_type like 'S062301%'     "
				// + "       and t.account_stat != '0110000013000000005'  "
				+ "      and t.bsflag = '0'     "
				+ "      and   (t.ifcountry ='����'  or t.ifcountry is null  )"
				+ "      and  t.dev_acc_id not in (select fk_dev_acc_id from gms_device_account_dui dui"
				+ "      where dui.bsflag = '0'  and dui.dev_type like 'S062301%' "
				+ "      and dui.actual_out_time is null and dui.is_leaving='0'  and dui.self_num is not null    )"
				// +
				// "      and ( t.using_stat!='0110000007000000001' or   t.using_stat is null)  and t.owning_sub_id='"
				+ "      and  t.owning_sub_id like  '"
				+ user.getSubOrgIDofAffordOrg()
				+ "%'"
				+ "     union all     "
				+ "     select count(*) as num, 'xczy'  as dev_type     "
				+ "      from gms_device_account_dui dui     "
				+ "      where dui.bsflag = '0'     "
				+ "       and dui.dev_type like 'S062301%'  and dui.actual_out_time is null and dui.is_leaving='0'  and dui.self_num  is not null   ";
		System.out.println("sql == " + sql);
		List<Map> list = jdbcDao.queryRecords(sql);
		Map showMap = new HashMap();
		showMap.put("xczy", "�ֳ���Դ(̨)");
		showMap.put("fxczy", "���ֳ���Դ(̨)");

		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		Map<String, String> msg = new HashMap<String, String>();
		for (int i = 0; i < list.size(); i++) {
			Element set = root.addElement("set");
			Map map = list.get(i);
			String key = map.get("dev_type").toString();
			String label = showMap.get(key).toString();
			set.addAttribute("label", label);
			String value = map.get("num") == null ? "0" : map.get("num")
					.toString();
			set.addAttribute("value", value);
			if (!key.equals("fxczy")) {
				set.addAttribute("link", "JavaScript:popProjectZyList()");
			} else {
				set.addAttribute("link", "JavaScript:popFxcZyList()");
			}
			msg.put(key, value);

		}
		String querySql = "select count(*) as num "
				+ "     from gms_device_account t     "
				+ "      where t.dev_type like 'S062301%'     "
				// + "       and t.account_stat != '0110000013000000005'  "
				+ "      and t.bsflag = '0'     "
				+ "      and   (t.ifcountry ='����'  or t.ifcountry is null  )  and t.owning_sub_id like'"
				+ user.getSubOrgIDofAffordOrg() + "%'";
		Map total = this.jdbcDao.queryRecordBySQL(querySql);
		responseDTO.setValue("Str", document.asXML());
		responseDTO.setValue("msg", msg);
		responseDTO.setValue("total", total);
		return responseDTO;
	}

	/**
	 * ������Ŀ��Դ����ͳ��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSingleProjectZyDev(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> projectList = new ArrayList<String>();
		String querySql = "";
		querySql = "select distinct  p.project_info_no, p.project_name"
				+ "    from gms_device_account_dui dui, gp_task_project p"
				+ "    where dui.project_info_id = p.project_info_no"
				+ "      and dui.bsflag = '0'"
				+ "     and  dui.actual_out_time is null and dui.is_leaving='0'  "
				+ "     and dui.dev_type like 'S062301%'  and dui.self_num is not null ";
		List<Map> projectMapList = this.jdbcDao.queryRecords(querySql);
		for (Map project : projectMapList) {
			String element = project.get("project_info_no") + "~"
					+ project.get("project_name");
			projectList.add(element);
		}

		String preSql = "     select count(*) as num "
				+ "     from gms_device_account_dui dui"
				+ "     where dui.dev_type like 'S062301%'"
				+ "      and dui.bsflag = '0'"
				+ "      and dui.self_num is not null "
				+ "      and dui.project_info_id = '@'";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		root.addAttribute("yAxisName", "��Դ����");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("exportDataMenuItemLabel", "���Ƶ����ư�...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");

		for (int i = 0; i < projectList.size(); i++) {
			String value = (String) projectList.get(i);
			String[] strArray = value.split("~");
			String project_info_id = strArray[0];
			String project_name = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			// ִ��Sql
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("�������ѯ�����ֶβ�����!");
			}
			// ����Ŀ��Դ����
			String zyNum = "";
			if (resultMap != null) {
				zyNum = resultMap.get("num") == null ? "0" : resultMap.get(
						"num").toString();

				// ƴXML�ĵ�
				Element category = categories.addElement("category");
				category.addAttribute("label", project_name);
				Element set = dataset.addElement("set");
				set.addAttribute("value", zyNum);
				set.addAttribute("link", "j-popDevArchiveBaseInfoList-"
						+ project_info_id);
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}
	/**
	 * ���װ����Դ��,�����ͼ����ʾ
	 * 
	 * @return dateSets
	 */
	public ISrvMsg getDeviceLieOne_coll(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "1";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
		String vcountry = "";
		if (StringUtils.isBlank(country)) {
			country = "";
		} else {
			if ("1".equals(country)) {
				vcountry = "����";
			}
			if ("2".equals(country)) {
				vcountry = "����";
			}
		}

		StringBuilder sql = new StringBuilder();
		sql.append("select  wm_concat(dev_name) dev_names,wm_concat(total_num) total_nums,wm_concat(unuse_num) unuse_nums,usage_org_name from (select dev_name,sum(total_num) total_num, sum(UNUSE_NUM) UNUSE_NUM, usage_org_name");
		sql.append(" from (select aa.dev_name,usage_org_name, UNUSE_NUM, (aa.unuse_num + aa.use_num + aa.other_num) as total_num");
		sql.append("  from (select tmp.*,");
		sql.append("               nvl((select sum(dui.unuse_num)");
		sql.append("                     from gms_device_coll_account_dui dui");
		sql.append("                     left join gp_task_project p  on p.project_info_no = dui.project_info_id");
		sql.append("                     left join gp_task_project_dynamic dy on dy.project_info_no = dui.project_info_id");
		sql.append("                    where dui.bsflag = '0' and dui.device_id = tmp.device_id  and tmp.org_id is not null and dy.org_subjection_id like      '%' || tmp.org_id || '%'), 0) as use_num");
				sql.append("          from (select acc.type_id,");
				sql.append("                       acc.device_id,");
				sql.append("                       acc.dev_acc_id,");
				sql.append("                       acc.dev_unit,");
				sql.append("                       acc.dev_model,");
				sql.append("               acc.dev_name,");
				sql.append("               nvl(teach.tocheck_num, 0) as tocheck_num,");
				sql.append("               nvl(teach.noreturn_num, 0) as noreturn_num,");
				sql.append("               teach.good_num as unuse_num,");
				sql.append("               (nvl(teach.touseless_num, 0) +");
				sql.append("               nvl(teach.torepair_num, 0) +");
				sql.append("               nvl(teach.repairing_num, 0) +");
				sql.append("               nvl(teach.tocheck_num, 0) +");
				sql.append("               nvl(teach.noreturn_num, 0) +");
				sql.append("               nvl(teach.destroy_num, 0)) as other_num,");
				sql.append("               case");
				sql.append("                  when acc.ifcountry = '000' then");
				sql.append("                  '����'");
				sql.append("                 else");
				sql.append("                  acc.ifcountry  end as ifcountry, ci.dev_code,");
				sql.append("               l.coding_name as dev_type, usageorg.org_abbreviation as usage_org_name,");
				sql.append("               owingorg.org_abbreviation as owning_org_name, unitsd.coding_name as unit_name,");
				sql.append("                org.org_abbreviation as org_name, acc.usage_sub_id,");
				sql.append("                acc.usage_org_id, acc.owning_org_id, acc.owning_sub_id, suborg.org_subjection_id,");
				sql.append("               case");
				sql.append("                 when usageorg.org_abbreviation = '����ľ��ҵ��' then");
				sql.append("                  'C105001005'");
				sql.append("                 when usageorg.org_abbreviation = '������ҵ��' then");
				sql.append("                 'C105001002'");
				sql.append("                  when usageorg.org_abbreviation = '�¹���ҵ��' then");
				sql.append("                 'C105001003'");
				sql.append("                when usageorg.org_abbreviation = '�ػ���ҵ��' then");
				sql.append("                  'C105001004'");
				sql.append("                 when usageorg.org_abbreviation = '������ҵ��' then");
                sql.append("                  'C105005004'");
                sql.append("                 when usageorg.org_abbreviation = '�ɺ���ҵ��' then");
                sql.append("                  'C105063'");
                sql.append("                 when usageorg.org_abbreviation = '������ҵ��' then");
                sql.append("                  'C105005000'");
                sql.append("                 when usageorg.org_abbreviation = '������ҵ��' then");
                sql.append("                  'C105005001'");
                sql.append("                 when usageorg.org_abbreviation = '�����ҵ�ֲ�' then");
                sql.append("                   'C105007'");
                sql.append("                 when usageorg.org_abbreviation = '�����豸��������' then");
                sql.append("                     'C105007'");
                sql.append("                 else ''");
                sql.append("               end as org_id");
                sql.append("          from gms_device_coll_account acc");
                sql.append("          left join comm_coding_sort_detail l on l.coding_code_id = acc.type_id and l.coding_sort_id like '5110000031'");
                sql.append("           left join gms_device_collectinfo ci  on acc.device_id = ci.device_id");
                sql.append("          left join comm_org_information org on acc.owning_org_id = org.org_id and org.bsflag = '0'");
                sql.append("          left join comm_org_information usageorg on acc.usage_org_id = usageorg.org_id and usageorg.bsflag = '0'");
                sql.append("          left join comm_org_information owingorg on acc.owning_org_id = owingorg.org_id and owingorg.bsflag = '0'");
                sql.append("          left join comm_org_subjection suborg on acc.owning_org_id = suborg.org_id and suborg.bsflag = '0'");
                sql.append("        left join comm_coding_sort_detail unitsd  on acc.dev_unit = unitsd.coding_code_id");
                sql.append("          left join gms_device_coll_account_tech teach on teach.dev_acc_id = acc.dev_acc_id");
                sql.append("         where acc.bsflag = '0' and ci.is_leaf = '1' and acc.usage_sub_id like 'C105%') tmp");
                sql.append("  where 1 = 1 " );
                if(StringUtils.isNotBlank(vcountry) ){
                sql.append("and ifcountry='"+vcountry+"'");
                }
                sql.append(	" and (tmp.dev_code like '01%' or tmp.dev_code like '02%' or tmp.dev_code like '03%' or tmp.dev_code like '05%')) aa where 1 = 1");
                sql.append(" order by usage_org_name, dev_type, case when dev_name = '��Դվ' then 'A' when dev_name = '����վ' then 'B' when dev_name = '�ɼ�վ' then 'C' else 'D' end)");
                sql.append(" where usage_org_name is not null and usage_org_name != '�����豸��������'and dev_name in ('����վ', '��Դվ', '�ɼ�վ')");
                sql.append(" group by dev_name, usage_org_name order by usage_org_name ) group by usage_org_name");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "��������");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		root.addAttribute("staggerLines", "3");
		root.addAttribute("caption", "");

		Element categories = root.addElement("categories");
		Element[] categorys = new Element[list.size()];
		
		Element datasetcjz = root.addElement("dataset");
		datasetcjz.addAttribute("seriesName", "�ɼ�վ");
		datasetcjz.addAttribute("color", "45b3ec");
		
		Element datasetjcz = root.addElement("dataset");
		datasetjcz.addAttribute("seriesName", "����վ");
		datasetjcz.addAttribute("color", "ec4224");
		Element datasetdyz = root.addElement("dataset");
		datasetdyz.addAttribute("seriesName", "��Դվ");
		datasetdyz.addAttribute("color", "ffd200");
		int cLevel = Integer.parseInt(level);// ��ǰ��ȡ����
		int nLevel = cLevel + 1;// ��һ��ȡ����
		double uncount = 0;
		double count = 0;
		// ��������
		if (CollectionUtils.isNotEmpty(list)) {
			for (int index = 0; index < list.size(); index++) {
				Map map = (Map) list.get(index);
				String [] totals=((String) map.get("total_nums")).split(",");
				String [] unuse_nums=((String) map.get("unuse_nums")).split(",");
				Element set = root.addElement("set");
				if (null != map.get("total_nums") ) {
					for (String string : totals) {
						count += Double
								.parseDouble(string);
					}
				}
				if (null != map.get("unuse_nums")) {
					for (String string : unuse_nums) {
						uncount += Double
								.parseDouble(string);
					}
				}
				categorys[index] = categories.addElement("category");
				
				
				//categorys[index].addAttribute("label", (String)dataMap.get("projectName"));
				categorys[index].addAttribute("label", (String)map.get("usage_org_name"));//���
				categorys[index].addAttribute("width", "24");
				categories.addAttribute("fontSize", "12");
				
				
				Element setcjz = datasetcjz.addElement("set");//�ɼ�վ
				setcjz.addAttribute("link",  "JavaScript:popDevList('�ɼ�վ','"+(String)map.get("usage_org_name")+"')");
				setcjz.addAttribute("value", unuse_nums[0]);
				setcjz.addAttribute("toolText","���� "+totals[0]+"̨,����"+unuse_nums[0]+"̨ ");
				
				Element setjcz = datasetjcz.addElement("set");//����վ
				setjcz.addAttribute("link",  "JavaScript:popDevList('����վ','"+(String)map.get("usage_org_name")+"')");
				setjcz.addAttribute("value", unuse_nums[1]);
				setjcz.addAttribute("toolText","���� "+totals[1]+"̨,����"+unuse_nums[1]+"̨ ");
				
				Element setdyz = datasetdyz.addElement("set");//��Դվ
				setdyz.addAttribute("link",  "JavaScript:popDevList('��Դվ','"+(String)map.get("usage_org_name")+"')");
				setdyz.addAttribute("value", unuse_nums[2]);
				setdyz.addAttribute("toolText","���� "+totals[2]+"̨,����"+unuse_nums[2]+"̨ ");

			}
		}
		double tempresult = 0;
		if (count >= 0) {
			tempresult = uncount / count;
		}
		DecimalFormat df1 = new DecimalFormat("0.00%");
		String result = df1.format(tempresult);
		root.addAttribute("subCaption", "��ǰ�����ʣ�" + result);
		responseDTO.setValue("xianzhilv", "��ǰ�����ʣ�" + result);
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}

	/**
	 * ����豸��Դ�أ���̨��,�����ͼ����ʾ
	 * 
	 * @return dateSets
	 */
	public ISrvMsg getDeviceLieOne(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "1";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
		String vcountry = "";
		if (StringUtils.isBlank(country)) {
			country = "";
		} else {
			if ("1".equals(country)) {
				vcountry = "����";
			}
			if ("2".equals(country)) {
				vcountry = "����";
			}
		}

		StringBuilder sql = new StringBuilder();
		sql.append("select cc.lable,cc.org_subjection_id,sum(cc.sum_day_num)as sum_day_num,sum(cc.ucout)as userate"
				+ " from ( select i.org_abbreviation as lable,s.org_subjection_id,"
				+ " count(dh.dev_acc_id) as sum_day_num,( case when (tech_stat = '0110000006000000001') then sum(ifunused) else sum(0) end) as ucout"
				+ " from (select t.dev_acc_id,t.ifcountry,t.ifunused,t.dev_type,t.using_stat,t.tech_stat,"
				+ " ( case when (t.owning_sub_id like 'C105001%' or t.owning_sub_id like 'C105005%') then substr(t.owning_sub_id, 0, 10)"
				+ " else substr(t.owning_sub_id, 0, 7) end ) as owning_sub_id FROM gms_device_account t"
				+ " left join comm_org_subjection s on t.owning_sub_id = s.org_subjection_id "
				+ " left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
				+ " left join dms_device_tree tree on tree.device_code = t.dev_type"
				+ " where t.bsflag = '0' and t.ifproduction = '5110000186000000001'"
				+ " and t.account_stat = '0110000013000000003' ) dh "
				+ " inner join(comm_org_subjection s inner join comm_org_information i on s.org_id = i.org_id) on dh.owning_sub_id = s.org_subjection_id "
				+ " where dh.dev_type in"
				+ " (select tree.device_code from dms_device_tree tree where tree.dev_tree_id like 'D002%' or tree.dev_tree_id like 'D003%'"
				+ " or tree.dev_tree_id like 'D004%' or tree.dev_tree_id like 'D006%' ) ");

		// ���ڹ���
		if (StringUtils.isNotBlank(country)) {
			sql.append(" and dh.ifcountry='" + vcountry + "'");
		}
		// �豸����
		if (StringUtils.isNotBlank(devTreeId)) {
			String types[] = devTreeId.split(",");
			sql.append("and (");
			for (int i = 0; i < types.length; i++) {
				if (i == 0) {
					sql.append(" dh.dev_type in (select tree.device_code from dms_device_tree tree  where tree.dev_tree_id  like '"
							+ types[i] + "%')");
				} else {
					sql.append(" or dh.dev_type in (select tree.device_code from dms_device_tree tree  where tree.dev_tree_id  like '"
							+ types[i] + "%')");
				}
			}
			sql.append(")");
		}
		sql.append(" group by dh.owning_sub_id, i.org_abbreviation, i.org_name,s.org_subjection_id,dh.using_stat,dh.tech_stat order by dh.owning_sub_id )cc"
				+ " where org_subjection_id in('C105002','C105001005','C105001002','C105001003','C105001004','C105005004','C105007','C105063','C105005000',"
				+ " 'C105005001','C105008','C105006','C105086','C105087') group by cc.lable,cc.org_subjection_id ");
		sql.append(" order by case cc.org_subjection_id when 'C105087' then 'A' when 'C105002' then 'B' when 'C105001005' then 'C'"
				+ " when 'C105001002' then 'D' when 'C105001003' then 'E' when 'C105001004' then 'F'"
				+ " when 'C105005004' then 'G' when 'C105007' then 'H' when 'C105063' then 'I'"
				+ " when 'C105005000' then 'J' when 'C105005001' then 'K' when 'C105086' then 'L'"
				+ " when 'C105008' then 'M' when 'C105006' then 'N' end ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "��������");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		int cLevel = Integer.parseInt(level);// ��ǰ��ȡ����
		int nLevel = cLevel + 1;// ��һ��ȡ����
		double uncount = 0;
		double count = 0;
		// ��������
		if (CollectionUtils.isNotEmpty(list)) {
			for (Map map : list) {
				Element set = root.addElement("set");
				if (null != map.get("sum_day_num")
						&& !"0".equals(map.get("sum_day_num").toString())) {
					count += Double
							.parseDouble((String) map.get("sum_day_num"));
				}
				if (null != map.get("userate")
						&& !"0".equals(map.get("userate").toString())) {
					uncount += Double.parseDouble((String) map.get("userate"));
				}

				String sumDayNum = map.get("sum_day_num").toString();// ��ǰ��������
				String orgSubIds = map.get("org_subjection_id").toString();// ��ǰ����ID
				String value = "0";// Ĭ�������
				set.addAttribute("label", map.get("lable").toString() + "("
						+ sumDayNum + ")");
				if (null != map.get("userate")
						&& !"0".equals(map.get("userate").toString())) {
					value = map.get("userate").toString();
					set.addAttribute("link", "JavaScript:popDevList('"
							+ devTreeId + "','" + orgSubIds + "','" + country
							+ "')");
					set.addAttribute("value", value);
				}

			}
		}
		double tempresult = 0;
		if (count >= 0) {
			tempresult = uncount / count;
		}
		DecimalFormat df1 = new DecimalFormat("0.00%");
		String result = df1.format(tempresult);
		root.addAttribute("subCaption", "��ǰ�����ʣ�" + result);
		responseDTO.setValue("xianzhilv", "��ǰ�����ʣ�" + result);
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}

	/**
	 * ����豸��Դ�أ���̨��,�����ͼ����ʾ
	 * 
	 * @return dateSets
	 */
	public ISrvMsg getcolljbqDeviceLieOne(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "1";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
		String vcountry = "";
		if (StringUtils.isBlank(country)) {
			country = "";
		} else {
			if ("1".equals(country)) {
				vcountry = "����";
			}
			if ("2".equals(country)) {
				vcountry = "����";
			}
		}

		StringBuilder sql = new StringBuilder();
		sql.append("SELECT owning_org_name lable, owning_sub_id org_subjection_id, sum(total_num) AS sum_day_num, sum(unuse_num) AS userate FROM(SELECT tmp.* FROM (SELECT (case WHEN (acc.owning_sub_id LIKE 'C105001%' OR acc.owning_sub_id LIKE 'C105005%') THEN substr(acc.owning_sub_id, 0, 10) ELSE substr(acc.owning_sub_id, 0, 7) end) AS owning_sub_id, suborg.org_subjection_id, acc.usage_org_id, acc.dev_acc_id, acc.dev_unit, nvl(acc.total_num, 0) total_num, nvl(acc.unuse_num, 0) unuse_num, acc.dev_name, acc.dev_model, nvl(acc.use_num, 0) use_num, CASE WHEN acc.ifcountry = '000' THEN '����' ELSE acc.ifcountry END AS ifcountry, nvl(acc.other_num, 0) other_num, ci.dev_code, ci.dev_name AS dev_type, usageorg.org_abbreviation AS usage_org_name, unitsd.coding_name AS unit_name, CASE WHEN suborg.org_subjection_id LIKE 'C105001005%' THEN '����ľ��̽��' WHEN suborg.org_subjection_id LIKE 'C105001002%' THEN '�½���̽��' WHEN suborg.org_subjection_id LIKE 'C105001003%' THEN '�¹���̽��' WHEN suborg.org_subjection_id LIKE 'C105001004%' THEN '�ຣ��̽��' WHEN suborg.org_subjection_id LIKE 'C105005004%' THEN '������̽��' WHEN suborg.org_subjection_id LIKE 'C105005000%' THEN '������̽��' WHEN suborg.org_subjection_id LIKE 'C105005001%' THEN '������̽��' WHEN suborg.org_subjection_id LIKE 'C105007%' THEN '�����̽��' WHEN suborg.org_subjection_id LIKE 'C105063%' THEN '�ɺ���̽��' WHEN suborg.org_subjection_id LIKE 'C105006%' THEN 'װ������' WHEN suborg.org_subjection_id LIKE 'C105002%' THEN '���ʿ�̽��ҵ��' WHEN suborg.org_subjection_id LIKE 'C105003%' THEN '�о�Ժ' WHEN suborg.org_subjection_id LIKE 'C105008%' THEN '�ۺ��ﻯ��' WHEN suborg.org_subjection_id LIKE 'C105015%' THEN '���е�������' ELSE '' END AS owning_org_name, acc.usage_sub_id FROM gms_device_coll_account acc LEFT JOIN gms_device_collectinfo ci ON acc.device_id = ci.device_id LEFT JOIN comm_org_information usageorg ON acc.usage_org_id = usageorg.org_id AND usageorg.bsflag = '0' LEFT JOIN comm_org_subjection suborg ON acc.owning_org_id = suborg.org_id AND suborg.bsflag = '0' LEFT JOIN comm_coding_sort_detail unitsd ON acc.dev_unit = unitsd.coding_code_id WHERE acc.bsflag = '0'" );
		// ���ڹ���
				if (StringUtils.isNotBlank(country)) {
					sql.append(" and acc.ifcountry='" + vcountry + "'");
				}
		sql.append(" AND ci.is_leaf = '1' AND (acc.owning_sub_id LIKE 'C105%' OR acc.usage_sub_id LIKE 'C105%')) tmp WHERE 1 = 1 AND (tmp.dev_code LIKE '04%' OR tmp.dev_code LIKE '06%')) GROUP BY owning_org_name,owning_sub_id ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "��������");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		int cLevel = Integer.parseInt(level);// ��ǰ��ȡ����
		int nLevel = cLevel + 1;// ��һ��ȡ����
		double uncount = 0;
		double count = 0;
		// ��������
		if (CollectionUtils.isNotEmpty(list)) {
			for (Map map : list) {
				Element set = root.addElement("set");
				if (null != map.get("sum_day_num")
						&& !"0".equals(map.get("sum_day_num").toString())) {
					count += Double
							.parseDouble((String) map.get("sum_day_num"));
				}
				if (null != map.get("userate")
						&& !"0".equals(map.get("userate").toString())) {
					uncount += Double.parseDouble((String) map.get("userate"));
				}

				String sumDayNum = map.get("sum_day_num").toString();// ��ǰ��������
				String orgSubIds = map.get("org_subjection_id").toString();// ��ǰ����ID
				String value = "0";// Ĭ�������
				set.addAttribute("label", map.get("lable").toString() + "("
						+ sumDayNum + ")");
				if (null != map.get("userate")
						&& !"0".equals(map.get("userate").toString())) {
					value = map.get("userate").toString();
					set.addAttribute("link", "JavaScript:popDevList('"
							+ devTreeId + "','" + orgSubIds + "','" + country
							+ "')");
					set.addAttribute("value", value);
				}

			}
		}
		double tempresult = 0;
		if (count >= 0) {
			tempresult = uncount / count;
		}
		DecimalFormat df1 = new DecimalFormat("0.00%");
		String result = df1.format(tempresult);
		root.addAttribute("subCaption", "��ǰ�����ʣ�" + result);
		responseDTO.setValue("xianzhilv", "��ǰ�����ʣ�" + result);
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * �����豸������ϸ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg gettjCheckInfo(ISrvMsg reqDTO) throws Exception {
		String device_appmix_id = reqDTO.getValue("devrecId");
		String mixId = reqDTO.getValue("mixId");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer()
				.append("select  wmsys.wm_concat(distinct((case     when (t.owning_sub_id like 'C105001%' or   t.owning_sub_id like 'C105005%') then     substr(t.owning_sub_id, 0, 10) ")
				.append(" else    substr(t.owning_sub_id, 0, 7)    end) ))as owning_sub_id   from GMS_DEVICE_ACCOUNT t      where t.dev_acc_id in ("
						+ mixId + ")      ");
		Map devicerecMap = jdbcDao.queryRecordBySQL(sb.toString());

		// ��ѯѡ�е��Ƿ������ڵ������豸
		StringBuffer sbs = new StringBuffer()
				.append("select  count(*) as name  ")
				.append("   from GMS_DEVICE_ACCOUNT t       where  t.saveflag='1' and t.dev_acc_id in ("
						+ mixId + ")      ");
		Map map = jdbcDao.queryRecordBySQL(sbs.toString());
		if (map != null) {
			devicerecMap.put("name", map.get("name").toString());
		}
		if (devicerecMap != null) {
			responseMsg.setValue("devicerecMap", devicerecMap);
		}
		return responseMsg;
	}

	/**
	 * ��ѯ���ڵ���̽��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgSubName(ISrvMsg reqDTO) throws Exception {
		String device_appmix_id = reqDTO.getValue("devrecId");
		String mixId = reqDTO.getValue("mixId");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer()
				.append("select  f.org_abbreviation as orgname from comm_org_information f left join comm_org_subjection s on s.org_id=f.org_id where s.org_subjection_id='"
						+ mixId + "' ");
		Map devicerecMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (devicerecMap != null) {
			responseMsg.setValue("devicerecMap", devicerecMap);
		}

		return responseMsg;
	}

	/**
	 * �����豸��������
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg approvalXZ(ISrvMsg reqDTO) throws Exception {
		String str = reqDTO.getValue("str");// ����״̬ 1����ͨ��2������ͨ��
		String device_mixInfo_id = reqDTO.getValue("device_mixInfo_id");// �������뵥ID
		String approval_desc = reqDTO.getValue("approval_desc");// �������
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// �ж��Ƿ������ʴ�����C105029
		if (user.getOrgSubjectionId().contains("C105029")) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("DEVICE_MIXINFO_ID", device_mixInfo_id);
			if (str.equals("1")) {
				dataMap.put("STATE", "1");
				String sql2 = "update gms_device_account t set t.using_stat='0110000007000000001' , t.ifunused='0' where t.dev_acc_id in( select d.dev_acc_id  from GMS_DEVICE_APPMIX_DETAIL d  where d.device_mix_subid='"
						+ device_mixInfo_id + "')";
				jdbcDao.executeUpdate(sql2);
			}
			if (str.equals("2")) {
				dataMap.put("STATE", "3");
				String sql = "update gms_device_mixinfo_form set bsflag='1' where device_mixinfo_id ='"
						+ device_mixInfo_id + "'";
				jdbcDao.executeUpdate(sql);
				String sql2 = "update gms_device_account t set t.saveflag='0' where t.dev_acc_id in( select d.dev_acc_id  from GMS_DEVICE_APPMIX_DETAIL d  where d.device_mix_subid='"
						+ device_mixInfo_id + "')";
				jdbcDao.executeUpdate(sql2);
			}
			dataMap.put("APPROVAL_DATE", currentdate);
			dataMap.put("APPROVAL_DESC", approval_desc);
			dataMap.put("APPROVALER", user.getUserId());
			jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_MIXINFO_FORM");
		} else {

			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("DEVICE_MIXINFO_ID", device_mixInfo_id);
			if (str.equals("1")) {
				dataMap.put("STATE", "4");
			}
			if (str.equals("2")) {
				dataMap.put("STATE", "3");
				String sql = "update gms_device_mixinfo_form set bsflag='1' where device_mixinfo_id ='"
						+ device_mixInfo_id + "'";
				jdbcDao.executeUpdate(sql);
				String sql2 = "update gms_device_account t set t.saveflag='0' where t.dev_acc_id in( select d.dev_acc_id  from GMS_DEVICE_APPMIX_DETAIL d  where d.device_mix_subid='"
						+ device_mixInfo_id + "')";
				jdbcDao.executeUpdate(sql2);
			}
			dataMap.put("WAPPROVAL_DATE", currentdate);
			dataMap.put("WAPPROVAL_DESC", approval_desc);
			dataMap.put("WAPPROVALER", user.getUserId());
			jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_MIXINFO_FORM");

		}

		return responseMsg;
	}

	/**
	 * ��ѯ��Ŀ���Ͷ�Ӧ�Ĳ˵�
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectTypeMenu(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String sql = "";
		// ��Ŀ����
		String projectType = msg.getValue("projectType");
		// ���Ŀ��ѯ�����Ա��ɫ��Ӧ�Ľ�ɫID
		if (projectType != null && projectType.equals("5000100004000000006")) {
			sql = " select * from p_auth_menu m where m.menu_id in  ( select z.menu_id from p_auth_role_menu z where z.role_id =��select   r.role_id   from p_auth_role r     where  r.role_c_name ='�DMS')) ";
		}
		// ½����Ŀ
		if (projectType != null
				&& (projectType.equals("5000100004000000001") || projectType
						.equals("5000100004000000007"))) {
			sql = " select * from p_auth_menu m where m.menu_id in  ( select z.menu_id from p_auth_role_menu z where z.role_id =��select   r.role_id   from p_auth_role r     where  r.role_c_name ='½��DMS')) ";
		}
		// ���ϵ���
		if (projectType != null && projectType.equals("5000100004000000002")) {
			sql = " select * from p_auth_menu m where m.menu_id in  ( select z.menu_id from p_auth_role_menu z where z.role_id =��select   r.role_id   from p_auth_role r     where  r.role_c_name ='����DMS')) ";
		}
		// ����
		if (projectType != null && projectType.equals("5000100004000000008")) {
			sql = " select * from p_auth_menu m where m.menu_id in  ( select z.menu_id from p_auth_role_menu z where z.role_id =��select   r.role_id   from p_auth_role r     where  r.role_c_name ='����DMS')) ";
		}
		// �ۺ��ﻯ̽
		if (projectType != null && projectType.equals("5000100004000000009")) {
			sql = " select * from p_auth_menu m where m.menu_id in  ( select z.menu_id from p_auth_role_menu z where z.role_id =��select   r.role_id   from p_auth_role r     where  r.role_c_name ='�ۺ�DMS')) ";
		}
		// ̲ǳ�����ɴ�
		if (projectType != null && projectType.equals("5000100004000000010")) {
			sql = " select * from p_auth_menu m where m.menu_id in  ( select z.menu_id from p_auth_role_menu z where z.role_id =��select   r.role_id   from p_auth_role r     where  r.role_c_name ='̲ǳDMS')) ";
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ��Դ��������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg zyWzOrder(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String project_info_id = msg.getValue("project_info_id");
		String postion = msg.getValue("postion");
		String wz_id = msg.getValue("wz_id");
		if ("".equals(postion) || null == postion) {
			postion = "0";
		}
		// ���Ϊ�� ����Ŀ�������� ��Ϊ�յ���Ŀ��������
		String sql = "";
		if ("".equals(project_info_id) || null == project_info_id) {
			sql = "select * from gms_mat_recyclemat_info  r  where r.wz_type='3' and r.bsflag='0' and r.project_info_id is null and r.wz_id='"
					+ wz_id + "'";
		} else {
			sql = "select * from gms_mat_recyclemat_info  r  where r.wz_type='3' and r.bsflag='0' and r.project_info_id='"
					+ project_info_id + "' and r.wz_id='" + wz_id + "'";
		}
		Map params = jdbcDao.queryRecordBySQL(sql);
		params.put("postion", postion);
		jdbcDao.saveOrUpdateEntity(params, "gms_mat_recyclemat_info");
		return responseDTO;
	}

	public ISrvMsg getKkzyTotal(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String sql = "     select sum(num) as total"
				+ "      from (select count(*) as num"
				+ "      from gms_device_zy_bywx      t,"
				+ "      gms_device_zy_wxbymat   w,"
				+ "       gms_mat_recyclemat_info r"
				+ "       where t.usemat_id = w.usemat_id"
				+ "       and r.project_info_id = t.project_info_id    and  w.wz_id=r.wz_id   "
				+ "      and t.bsflag = '0'"
				+ "       and r.bsflag = '0'"
				+ "      and r.project_info_id is not null"
				+ "       and t.project_info_id is not null"
				+ "       and r.wz_type = '3'"
				+ "      union all"
				+ "     select count(*) as num"
				+ "       from gms_device_zy_bywx      t,"
				+ "           gms_device_zy_wxbymat   w,"
				+ "          gms_mat_recyclemat_info r"
				+ "      where t.usemat_id = w.usemat_id   and  w.wz_id=r.wz_id  "
				+ "       and t.bsflag = '0'" + "       and r.bsflag = '0'"
				+ "       and r.project_info_id is null"
				+ "       and t.project_info_id is null"
				+ "       and r.wz_type = '3'" + "        union all"
				+ "       select count(*) as num"
				+ "        from gms_device_zy_bywx t"
				+ "       where t.usemat_id is null"
				+ "        and t.bsflag = '0'" + "      union all"
				+ "      select count(*) as num"
				+ "       from gms_device_zy_bywx t"
				+ "      where t.bsflag = '0'"
				+ "        and t.usemat_id not in"
				+ "           (select usemat_id from gms_device_zy_wxbymat)"
				+ "           and t.usemat_id  is not null ) a";

		Map data = jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("data", data);
		return responseDTO;
	}

	/**
	 * ������ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg getNoticeDetail(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		JdbcTemplate jdbcTemplate = this.jdbcDao.getJdbcTemplate();
		String notice_id = msg.getValue("notice_id");
		String querySql = "select * from DMS_COMM_NOTICE t where t.notice_id=? and t.bsflag='0'";
		Map<String, Object> data = jdbcTemplate.queryForMap(querySql,
				new Object[] { notice_id });
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		String create_date = data.get("CREATE_DATE").toString();
		create_date = sf.format(sf.parse(create_date));
		data.put("CREATE_DATE", create_date);
		responseDTO.setValue("notice", data);
		return responseDTO;
	}

	/**
	 * ����
	 */
	public ISrvMsg getNoticeUpFile(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		// ���ݹ���������ø�����Ϣ
		String notice_id = msg.getValue("notice_id");
		String queryUpFileSql = "select * from BGP_DOC_GMS_FILE t where t.relation_id='"
				+ notice_id + "' and t.bsflag='0'";
		List<Map> upFileMapList = this.jdbcDao.queryRecords(queryUpFileSql);
		responseDTO.setValue("upFile", upFileMapList);
		return responseDTO;
	}

	public ISrvMsg deleteNotice(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		String notice_id = msg.getValue("notice_id");
		String deleteSql = "update dms_comm_notice set bsflag='1' where notice_id='"
				+ notice_id + "'";
		String fileDeleteSql = "  update BGP_DOC_GMS_FILE  set bsflag='1' where relation_id='"
				+ notice_id + "'";
		this.jdbcDao.executeUpdate(deleteSql);
		this.jdbcDao.executeUpdate(fileDeleteSql);
		return responseDTO;
	}

	/**
	 * ֪ͨ����
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg noticeEdit(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		JdbcTemplate jdbcTemplate = this.jdbcDao.getJdbcTemplate();
		// ��ȡһ������
		String notice_id = msg.getValue("notice_id");
		notice_id = this.isNullOrEmpty(notice_id);
		String notice_title = msg.getValue("notice_title");
		notice_title = this.isNullOrEmpty(notice_title);
		String notice_content = msg.getValue("notice_content");
		notice_content = this.isNullOrEmpty(notice_content);
		String notice_type = msg.getValue("notice_type");
		String remark = msg.getValue("remark");
		remark = this.isNullOrEmpty(remark);
		SimpleDateFormat sd = new SimpleDateFormat("yyyy/MM/dd");
		String time = sd.format(new Date());
		if (null == notice_id || "".equals(notice_id)) {
			String org_id = user.getOrgId();
			String org_sub_id = user.getOrgSubjectionId();
			notice_id = UUID.randomUUID().toString().replaceAll("-", "");

			String insertSql = "insert  into  DMS_COMM_NOTICE (notice_id,notice_title,notice_content,creater,create_date,"
					+ "updator,modify_date,bsflag,notice_type,remark,org_id,org_sub_id,real_user_name)  "
					+ "values('"
					+ notice_id
					+ "','"
					+ notice_title
					+ "','"
					+ notice_content
					+ "','"
					+ user.getUserId()
					+ "',to_date('"
					+ time
					+ "','yyyy/mm/dd'),'"
					+ user.getUserId()
					+ "',to_date('"
					+ time
					+ "','yyyy/mm/dd'),'"
					+ 0
					+ "',"
					+ notice_type
					+ ",'"
					+ remark
					+ "','"
					+ org_id
					+ "','"
					+ org_sub_id
					+ "','" + user.getUserName() + "')";
			jdbcTemplate.update(insertSql);
			// �����ϴ��ļ�
			this.saveUpFile(msg, notice_id, user);

		} else {
			String updateSql = "update DMS_COMM_NOTICE  set updator='"
					+ user.getUserId() + "',modify_date=to_date('" + time
					+ "','yyyy/mm/dd'),notice_title='" + notice_title
					+ "',notice_type='" + notice_type + "' ,notice_content='"
					+ notice_content + "' where notice_id ='" + notice_id + "'";
			jdbcTemplate.update(updateSql);
			this.saveUpFile(msg, notice_id, user);
		}
		return responseDTO;
	}

	/**
	 * �����ϴ����ļ�
	 * 
	 * @param isrvmsg
	 * @param notice_id
	 */
	private void saveUpFile(ISrvMsg isrvmsg, String notice_id, UserToken user) {
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		List<WSFile> files = mqMsg.getFiles();
		try {
			// ������
			for (WSFile file : files) {
				String filename = file.getFilename();
				String fileOrder = file.getKey().toString().split("__")[1];
				MyUcm ucm = new MyUcm();
				String ucmDocId = ucm.uploadFile(file.getFilename(),
						file.getFileData());

				Map doc = new HashMap();
				doc.put("file_name", filename);
				String fileType = isrvmsg.getValue("doc_type__" + fileOrder);
				doc.put("file_type", fileType);
				doc.put("ucm_id", ucmDocId);
				doc.put("is_file", "1");
				doc.put("relation_id", notice_id);
				doc.put("bsflag", "0");
				doc.put("create_date", currentdate);
				doc.put("creator_id", user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				String docId = (String) jdbcDao.saveOrUpdateEntity(doc,
						"BGP_DOC_GMS_FILE");
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(),
						user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(),
						user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
			}

		} catch (Exception e) {

		}
	}

	private String isNullOrEmpty(String value) {
		if (null == value || "".equals(value)) {
			return "";
		}
		return value;
	}

	/**
	 * ��ѯ�豸��Ϣ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getdeviceMoveInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_id = msg.getValue("wz_id");
		String querysgllSql = "select t.dev_acc_id,t.dev_name,t.dev_model,nvl(teach.good_num,0) as wanhao_num,   nvl(teach.touseless_num, 0) as daibaofei_num,  nvl(teach.torepair_num, 0) as weixiu_num, nvl(teach.repairing_num, 0) as zaixiu_num, nvl(teach.destroy_num, 0) as huisun_num from gms_device_coll_account t  left join gms_device_coll_account_tech teach on teach.dev_acc_id =t.dev_acc_id where  t.dev_acc_id in ("
				+ wz_id + ") ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ��ȡ��Ҫ�豸�������ͳ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTableChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//�ʲ�״̬
		String account_stat = isrvmsg.getValue("account_stat");
		if (StringUtils.isBlank(account_stat)) {
			account_stat = "";
		}
		// ��̽��
		String wutanorg = isrvmsg.getValue("wutanorg");
		if (StringUtils.isBlank(wutanorg)) {
			wutanorg = "";
		}
		StringBuilder sql = new StringBuilder(
				"select t.*,case when d.device_type is null then d.device_name else d.device_name||'('||d.device_type||')' end as device_name,"
						+ " case when d.dev_tree_id like 'D001%' then '��'  when d.dev_tree_id like 'D002%' or d.dev_tree_id like 'D003%'  then '̨'"
						+ " when d.dev_tree_id like 'D005%' then '��'  when d.dev_tree_id like 'D004%' or d.dev_tree_id like 'D006%'  then '��' when d.dev_tree_id like 'D007%' then '��' end as unit"
						+ " from (select substr(dt.dev_tree_id, 1, 4) as device_code,"
						+ " sum(nvl(case when tdh.country='����' then tdh.sum_num end ,0)) as sum_num_in,"
						+ " sum(nvl(case when tdh.country='����' then tdh.sum_num end ,0)) as sum_num_out,"
						+ " sum(nvl(case when tdh.country='����' and tdh.account_stat != '0110000013000000001' then tdh.use_num end,0)) as use_num_in,"
						+ " sum(nvl(case when tdh.country='����' and tdh.account_stat != '0110000013000000001' then tdh.use_num end,0)) as use_num_out,"
						+ " sum(nvl(case when tdh.country='����' and tdh.account_stat = '0110000013000000001' then tdh.use_num end,0)) as scrap_num_in,"
						+ " sum(nvl(case when tdh.country='����' and tdh.account_stat = '0110000013000000001' then tdh.use_num end,0)) as scrap_num_out,"
						+ " sum(nvl(case when tdh.country='����' then tdh.idle_num end,0)) as idle_num_in,"
						+ " sum(nvl(case when tdh.country='����' then tdh.idle_num end,0)) as idle_num_out,"
						+ " sum(nvl(case when tdh.country='����' then tdh.repairing_num end,0)) as repairing_num_in,"
						+ " sum(nvl(case when tdh.country='����' then tdh.repairing_num end,0)) as repairing_num_out,"
						+ " sum(nvl(case when tdh.country='����' then tdh.wait_repair_num end,0)) as wait_repair_num_in,"
						+ " sum(nvl(case when tdh.country='����' then tdh.wait_repair_num end,0)) as wait_repair_num_out,"
						+ " sum(nvl(case when tdh.country='����' then tdh.wait_scrap_num end,0)) as wait_scrap_num_in,"
						+ " sum(nvl(case when tdh.country='����' then tdh.wait_scrap_num end,0)) as wait_scrap_num_out,"
						+ " sum(nvl(case when tdh.country='����' then tdh.onway_num end,0)) as onway_num_in,"
						+ " sum(nvl(case when tdh.country='����' then tdh.onway_num end,0)) as onway_num_out"
						+ " from dms_device_tree dt"
						+ " left join ( select * from gms_device_dailyhistory dh"
						+ " where dh.bsflag = '0'  and dh.country in ('����','����')");
						if(StringUtils.isNotBlank(account_stat)){
							sql.append("and  account_stat = '"+account_stat+"'");
						}
						sql.append( " and dh.his_date=(select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");

		// ��̽��
		if (StringUtils.isNotBlank(wutanorg) && (!"C105".equals(wutanorg))) {
			sql.append(" and dh.org_subjection_id like '" + wutanorg + "%'");
		}
		sql.append(" ) tdh on tdh.device_type = dt.device_code where dt.bsflag='0'");
		sql.append(" group by substr(dt.dev_tree_id, 1,4)) t "
				+ "left join dms_device_tree d on t.device_code = d.dev_tree_id order by d.code_order");
		System.out.println("sql == " + sql.toString());
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * ��ȡ��Ҫ�豸�������ͳ�Ʒ�������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMainEquiBaseChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// �ʲ�״̬
		String account_stat = isrvmsg.getValue("account_stat");
		if (StringUtils.isBlank(account_stat)) {
			account_stat = "";
		}
		// ��̽��
		String wutanorg = isrvmsg.getValue("wutanorg");
		if (StringUtils.isBlank(wutanorg)) {
			wutanorg = "";
		}
		// ����(Ĭ��Ϊ�ڶ���)
		String level = isrvmsg.getValue("level");
		if (StringUtils.isBlank(level)) {
			level = "2";
		}
		// ��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level) * 3;
		// ������
		String parentCode = isrvmsg.getValue("parentCode");
		if (StringUtils.isBlank(parentCode)) {
			parentCode = "";
		}
		// ͳ�����
		String analType = isrvmsg.getValue("analType");
		if (StringUtils.isBlank(analType)) {
			analType = "";
		}
		// ���ڹ���
		String ifCountry = isrvmsg.getValue("ifCountry");
		String country = "";
		if (StringUtils.isBlank(ifCountry)) {
			country = "";
		} else {
			if ("in".equals(ifCountry)) {
				country = "����";
			}
			if ("out".equals(ifCountry)) {
				country = "����";
			}
		}
		StringBuilder sql = new StringBuilder(
				"select t.*,case when d.device_type is null then d.device_name else d.device_type end as device_name,"
						+ " case when d.dev_tree_id like 'D001%' then '��'  when d.dev_tree_id like 'D002%' or d.dev_tree_id like 'D003%'  then '̨'"
						+ " when d.dev_tree_id like 'D005%' then '��'  when d.dev_tree_id like 'D004%' or d.dev_tree_id like 'D006%'  then '��' when d.dev_tree_id like 'D007%' then '��'  end as unit"
						+ " from (select substr(dt.dev_tree_id, 1, "
						+ subStrLength
						+ ") as device_code,"
						+ " sum(nvl(tdh.sum_num,0)) as sum_num,"
						+ " sum(nvl(case when tdh.account_stat != '0110000013000000001' then tdh.use_num end,0)) as use_num,"
						+ " sum(nvl(case when tdh.account_stat = '0110000013000000001' then tdh.use_num end,0)) as scrap_num,"
						+ " sum(nvl(tdh.idle_num,0)) as idle_num,"
						+ " sum(nvl(tdh.repairing_num,0)) as repairing_num,"
						+ " sum(nvl(tdh.wait_repair_num,0)) as wait_repair_num,"
						+ " sum(nvl(tdh.wait_scrap_num,0)) as wait_scrap_num,"
						+ " sum(nvl(tdh.onway_num,0)) as onway_num"
						+ " from dms_device_tree dt"
						+ " left join ( select * from gms_device_dailyhistory dh"
						+ " where dh.bsflag = '0' and dh.country in ('����','����')");
						if(StringUtils.isNotBlank(account_stat)){
							sql.append(" and account_stat='"+account_stat+"'");
						}
						sql.append( " and dh.his_date=(select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");

		// ��̽��
		if (StringUtils.isNotBlank(wutanorg) && (!"C105".equals(wutanorg))) {
			sql.append(" and dh.org_subjection_id like '" + wutanorg + "%'");
		}
		// ���ڹ���
		if (StringUtils.isNotBlank(country)) {
			sql.append(" and dh.country='" + country + "'");
		}
		sql.append(" ) tdh on tdh.device_type = dt.device_code where dt.bsflag='0'");
		// tree����
		if (StringUtils.isNotBlank(parentCode)) {
			sql.append(" and dt.dev_tree_id like '" + parentCode
					+ "%' and dt.device_code is not null");
		}
		sql.append(" group by substr(dt.dev_tree_id, 1,"
				+ subStrLength
				+ ")) t "
				+ "left join dms_device_tree d on t.device_code = d.dev_tree_id order by d.code_order");
	
		String pSql = "select case when dt.device_type is not null then dt.device_type else dt.device_name end as device_name from dms_device_tree dt where dt.bsflag='0' and dt.dev_tree_id='"
				+ parentCode + "'";
		Map pMap = jdbcDao.queryRecordBySQL(pSql);
		
		String sql5="select t.*, case when '"+parentCode+"' like 'D001%' then '��' when '"+parentCode+"' like 'D002%' or '"+parentCode+"' like 'D003%' then '̨' when '"+parentCode+"' like 'D005%' then '��' when '"+parentCode+"' like 'D004%' or '"+parentCode+"' like 'D006%' then '��' when '"+parentCode+"' like 'D007%' then '��' end as unit, '"+parentCode+"' device_code from(select sum(decode('1', '1', 1, 0)) as sum_num, sum(decode(acc.using_stat, '0110000007000000001', 1, 0)) as use_num, sum(decode(acc.using_stat, '0110000007000000002', 1, 0)) as idle_num, sum(case when (acc.using_stat = '0110000007000000001' and acc.using_stat = '0110000013000000001') then 1 else 0 end) as scrap_num, sum(decode(acc.tech_stat, '0110000006000000007', 1, 0)) as repairing_num, sum(decode(acc.tech_stat, '0110000006000000006', 1, 0)) as wait_repair_num, sum(decode(acc.tech_stat, '0110000006000000005', 1, 0)) as wait_scrap_num, inf.org_abbreviation device_name,acc.owning_sub_id org_subjection_id from gms_device_account acc left join dms_device_tree dt on acc.dev_type = dt.device_code left join comm_org_information inf on acc.owning_org_id = inf.org_id and inf.bsflag = '0' where acc.owning_sub_id like '"+wutanorg+"%' and dt.dev_tree_id like '"+parentCode+"%' and acc.bsflag = '0'" ;
				// ���ڹ���
				if (StringUtils.isNotBlank(country)) {
				sql5+=" and acc.ifcountry='"+country+"' ";
				}
				sql5+=" and (acc.account_stat = '0110000013000000003' or acc.account_stat = '0110000013000000006' or (acc.account_stat = '0110000013000000001' and acc.ifscrapleft = '1')) group by inf.org_abbreviation,acc.owning_sub_id) t ";
		StringBuilder sql4 = new StringBuilder(
				"select t.*,inf.org_abbreviation as device_name from (select tdh.org_subjection_id,"
				+ " sum(nvl(tdh.sum_num,0)) as sum_num,"
				+ " sum(nvl(case when tdh.account_stat != '0110000013000000001' then tdh.use_num end,0)) as use_num,"
				+ " sum(nvl(case when tdh.account_stat = '0110000013000000001' then tdh.use_num end,0)) as scrap_num,"
				+ " sum(nvl(tdh.idle_num,0)) as idle_num,"
				+ " sum(nvl(tdh.repairing_num,0)) as repairing_num,"
				+ " sum(nvl(tdh.wait_repair_num,0)) as wait_repair_num,"
				+ " sum(nvl(tdh.wait_scrap_num,0)) as wait_scrap_num,"
				+ " sum(nvl(tdh.onway_num,0)) as onway_num,"
				+ " case"
				+ "  when '"+parentCode+"' like 'D001%' then"
				+ "   '��'"
				+ " when '"+parentCode+"' like 'D002%' or '"+parentCode+"' like 'D003%' then"
				+ "   '̨'"
				+ "    when '"+parentCode+"' like 'D005%' then"
				+ "    '��'"
				+ "   when '"+parentCode+"' like 'D004%' or '"+parentCode+"' like 'D006%' then"
				+ "   '��'"
				+ "  when '"+parentCode+"' like 'D007%' then"
				+ " '��'"
				+ " end as unit,'"+parentCode+"' device_code"
				+ " from dms_device_tree dt"
				+ " inner join ( select * from gms_device_dailyhistory dh"
				+ " where dh.bsflag = '0' and dh.country in ('����','����')");
				if(StringUtils.isNotBlank(account_stat)){
					sql4.append(" and  dh.account_stat = '"+account_stat+"' ");
				}
				sql4.append( " and dh.his_date=(select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");

			// ���ڹ���
			if (StringUtils.isNotBlank(country)) {
				sql4.append(" and dh.country='" + country + "' and dh.org_subjection_id like '"+wutanorg+"%'");
			}
			sql4.append(" ) tdh on tdh.device_type = dt.device_code where dt.bsflag='0' and dt.device_code is not null");
			// tree����
			if (StringUtils.isNotBlank(parentCode)) {
				sql4.append(" and dt.dev_tree_id like '" + parentCode + "%' ");
			}
			sql4.append(" group by tdh.org_subjection_id ) t left join comm_org_subjection sub"
					+ " on t.org_subjection_id=sub.org_subjection_id and sub.bsflag='0'"
					+ " left join comm_org_information inf on sub.org_id=inf.org_id and inf.bsflag='0'");
			String other_sql="select count(*) "+analType+"_num,"
					+ "  dev_position device_name,"
					+ "   unit,"
					+ "  '"+parentCode+"' device_code,postion_id"
					+ "   from (select (select p.pos_name"
					+ "   from gms_device_position p"
					+ "     where substr(acc.position_id,0,3)||'000' = p.pos_id) dev_position,substr(acc.position_id,0,3) postion_id,"
					+ "   case"
					+ "     when dt.dev_tree_id like 'D001%' then"
					+ "       '��'"
					+ "      when dt.dev_tree_id like 'D002%' or"
					+ "           dt.dev_tree_id like 'D003%' then"
					+ "       '̨'"
					+ "      when dt.dev_tree_id like 'D005%' then"
					+ "        '��'"
					+ "      when dt.dev_tree_id like 'D004%' or"
					+ "           dt.dev_tree_id like 'D006%' then"
					+ "       '��'"
					+ "      when dt.dev_tree_id like 'D007%' then"
					+ "       '��'"
					+ "    end as unit"
					+ "  from gms_device_account acc"
					+ "  left join dms_device_tree dt"
					+ "     on dt.device_code = acc.dev_type";
					if("idle".equals(analType)){
					other_sql+="   where acc.using_stat = '0110000007000000002'";
					}
					if("repairing".equals(analType)){//����
						other_sql+="   where acc.tech_stat = '0110000006000000007'";
					}
					if("wait_repair".equals(analType)){//����
						other_sql+="   where acc.tech_stat = '0110000006000000006'";
					}
					if("wait_scrap".equals(analType)){//������
						other_sql+="   where acc.tech_stat = '0110000006000000005'";
					}
					other_sql+= "     and acc.account_stat like '"+account_stat+"%'"
					+ "     and dt.dev_tree_id like '"+parentCode+"%'"
					+ "     and acc.owning_sub_id like '"+wutanorg+"%'"
					+ "     and acc.ifcountry = '"+country+"'"          
					+ "     and acc.bsflag = '0')"
					+ " group by dev_position, unit,postion_id";
		String sql6="select t.*, " 
        +" case "
        +"  when '"+parentCode+"' like 'D001%' then"
       +"    '��'"
       +"   when '"+parentCode+"' like 'D002%' or '"+parentCode+"' like 'D003%' then"
       +"    '̨'"
       +"   when '"+parentCode+"' like 'D005%' then"
       +"    '��'"
       +"   when '"+parentCode+"' like 'D004%' or '"+parentCode+"' like 'D006%' then"
      +"     '��'"
      +"    when '"+parentCode+"' like 'D007%' then"
      +"     '��'"
      +"  end as unit,"
     +"   '"+parentCode+"' device_code"
     +"  from (select sum(nvl(acc.total_num,0)) as sum_num,"
     +"             inf.org_abbreviation device_name,"
     +"             acc.owning_sub_id org_subjection_id"
     +"        from gms_device_coll_account acc"
     +"        left join gms_device_collectinfo info"
     +" 			   on acc.device_id = info.device_id"
     +"         and  ( info.dev_code )in  (select distinct device_code from dms_device_tree dt where     dt.dev_tree_id like ' "+parentCode+"%')"
     +"       left join comm_org_information inf"
     +"         on acc.owning_org_id = inf.org_id"
     +"        and inf.bsflag = '0'"
     +"      where acc.owning_sub_id like '"+wutanorg+"%'"
     +"        and acc.bsflag = '0'"
     +"        and acc.ifcountry = '"+country+"' "
     +"      group by inf.org_abbreviation, acc.owning_sub_id) t";
		// ����xml����
		int cLevel = Integer.parseInt(level);// ��ǰ��ȡ����
		int nLevel = cLevel + 1;// ��һ��ȡ����
		
		List<Map> list = null;
		if(cLevel==4){
			if("C105".equals(wutanorg)){
			list=jdbcDao.queryRecords(sql4.toString());
			}else{
			if(parentCode.startsWith("D005")){
			list=jdbcDao.queryRecords(sql6.toString());
			}else{
			list=jdbcDao.queryRecords(sql5.toString());	
			}
			}
		}else if (cLevel==5){
			list=jdbcDao.queryRecords(other_sql.toString());
		}
		else{
			list=jdbcDao.queryRecords(sql.toString());
		}
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		if (MapUtils.isNotEmpty(pMap) && null != pMap.get("device_name")) {
			root.addAttribute("caption", pMap.get("device_name").toString());
		}
		// ��������
		if (CollectionUtils.isNotEmpty(list) && list.size() > 0) {
			root.addAttribute("yAxisName", "��λ��"
					+ list.get(0).get("unit").toString());
			if ("".equals(analType)) {
				Element categories = root.addElement("categories");
				Element dataset1 = root.addElement("dataset");
				dataset1.addAttribute("seriesName", "����");
				Element dataset2 = root.addElement("dataset");
				dataset2.addAttribute("seriesName", "���-���ã��������ϣ�");
				Element dataset3 = root.addElement("dataset");
				dataset3.addAttribute("seriesName", "���-���ã������ϣ�");
				Element dataset4 = root.addElement("dataset");
				dataset4.addAttribute("seriesName", "���-����");
				Element dataset5 = root.addElement("dataset");
				dataset5.addAttribute("seriesName", "����");
				Element dataset6 = root.addElement("dataset");
				dataset6.addAttribute("seriesName", "����");
				Element dataset7 = root.addElement("dataset");
				dataset7.addAttribute("seriesName", "������");
				Element dataset8 = root.addElement("dataset");
				dataset8.addAttribute("seriesName", "��;");
				for (Map map : list) {
					Element category = categories.addElement("category");
					category.addAttribute("label", map.get("device_name")
							.toString());
					Element set1 = dataset1.addElement("set");
					set1.addAttribute("value", map.get("sum_num").toString());
					Element set2 = dataset2.addElement("set");
					set2.addAttribute("value", map.get("use_num").toString());
					Element set3 = dataset3.addElement("set");
					set3.addAttribute("value", map.get("scrap_num").toString());
					Element set4 = dataset4.addElement("set");
					set4.addAttribute("value", map.get("idle_num").toString());
					Element set5 = dataset5.addElement("set");
					set5.addAttribute("value", map.get("repairing_num")
							.toString());
					Element set6 = dataset6.addElement("set");
					set6.addAttribute("value", map.get("wait_repair_num")
							.toString());
					Element set7 = dataset7.addElement("set");
					set7.addAttribute("value", map.get("wait_scrap_num")
							.toString());
					Element set8 = dataset8.addElement("set");
					set8.addAttribute("value", map.get("onway_num").toString());
					String device_code = map.get("device_code").toString();
					if (	device_code.startsWith("D002")
							|| device_code.startsWith("D007")
							|| device_code.startsWith("D001")
							|| device_code.startsWith("D003")
							|| device_code.startsWith("D004")
							|| device_code.startsWith("D005")
							|| device_code.startsWith("D006")) {
						if ((!device_code.startsWith("D004003"))
								&& (!device_code.startsWith("D005003"))) {
							if (cLevel <= 3 ) {
								
								set1.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
								set2.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
								set3.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
								set4.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
								set5.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
								set6.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
								set7.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
								set8.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
							} else {
								if (1==1) {//"C105".equals(wutanorg)
									if(cLevel==4){
										wutanorg=	(String) map.get("org_subjection_id")	;
									}
									set1.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"')");
									set2.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"')");
									set3.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"')");
									set4.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"')");
									set5.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"')");
									set6.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"')");
									set7.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"')");
									set8.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"')");
								}
							}
						} else {
							if (1==1) {//"C105".equals(wutanorg)
								if(cLevel==4){
									wutanorg=	(String) map.get("org_subjection_id")	;
								}
								set1.addAttribute("link",
										"JavaScript:popDevOrgAnal('"
												+ device_code + "','"
												+ ifCountry + "','" + analType
												+ "','"+wutanorg+"')");
								set2.addAttribute("link",
										"JavaScript:popDevOrgAnal('"
												+ device_code + "','"
												+ ifCountry + "','" + analType
												+ "','"+wutanorg+"')");
								set3.addAttribute("link",
										"JavaScript:popDevOrgAnal('"
												+ device_code + "','"
												+ ifCountry + "','" + analType
												+ "','"+wutanorg+"')");
								set4.addAttribute("link",
										"JavaScript:popDevOrgAnal('"
												+ device_code + "','"
												+ ifCountry + "','" + analType
												+ "','"+wutanorg+"')");
								set5.addAttribute("link",
										"JavaScript:popDevOrgAnal('"
												+ device_code + "','"
												+ ifCountry + "','" + analType
												+ "','"+wutanorg+"')");
								set6.addAttribute("link",
										"JavaScript:popDevOrgAnal('"
												+ device_code + "','"
												+ ifCountry + "','" + analType
												+ "','"+wutanorg+"')");
								set7.addAttribute("link",
										"JavaScript:popDevOrgAnal('"
												+ device_code + "','"
												+ ifCountry + "','" + analType
												+ "','"+wutanorg+"')");
								set8.addAttribute("link",
										"JavaScript:popDevOrgAnal('"
												+ device_code + "','"
												+ ifCountry + "','" + analType
												+ "','"+wutanorg+"')");
							}
						}
					} else {
						if (1==1) {//"C105".equals(wutanorg)
							if(cLevel==4){
								wutanorg=	(String) map.get("org_subjection_id")	;
							}
							set1.addAttribute("link",
									"JavaScript:popDevOrgAnal('" + device_code
											+ "','" + ifCountry + "','"
											+ analType + "','"+wutanorg+"')");
							set2.addAttribute("link",
									"JavaScript:popDevOrgAnal('" + device_code
											+ "','" + ifCountry + "','"
											+ analType + "','"+wutanorg+"')");
							set3.addAttribute("link",
									"JavaScript:popDevOrgAnal('" + device_code
											+ "','" + ifCountry + "','"
											+ analType + "','"+wutanorg+"')");
							set4.addAttribute("link",
									"JavaScript:popDevOrgAnal('" + device_code
											+ "','" + ifCountry + "','"
											+ analType + "','"+wutanorg+"')");
							set5.addAttribute("link",
									"JavaScript:popDevOrgAnal('" + device_code
											+ "','" + ifCountry + "','"
											+ analType + "','"+wutanorg+"')");
							set6.addAttribute("link",
									"JavaScript:popDevOrgAnal('" + device_code
											+ "','" + ifCountry + "','"
											+ analType + "','"+wutanorg+"')");
							set7.addAttribute("link",
									"JavaScript:popDevOrgAnal('" + device_code
											+ "','" + ifCountry + "','"
											+ analType + "','"+wutanorg+"')");
							set8.addAttribute("link",
									"JavaScript:popDevOrgAnal('" + device_code
											+ "','" + ifCountry + "','"
											+ analType + "','"+wutanorg+"')");
						}
					}
				}
			} else {
				Element categories = root.addElement("categories");
				Element dataset = root.addElement("dataset");
				if ("sum".equals(analType)) {
					dataset.addAttribute("seriesName", "����");
				}
				if ("use".equals(analType)) {
					dataset.addAttribute("seriesName", "���-���ã��������ϣ�");
				}
				if ("scrap".equals(analType)) {
					dataset.addAttribute("seriesName", "���-���ã������ϣ�");
				}
				if ("idle".equals(analType)) {
					dataset.addAttribute("seriesName", "���-����");
				}
				if ("repairing".equals(analType)) {
					dataset.addAttribute("seriesName", "����");
				}
				if ("wait_repair".equals(analType)) {
					dataset.addAttribute("seriesName", "����");
				}
				if ("wait_scrap".equals(analType)) {
					dataset.addAttribute("seriesName", "������");
				}
				if ("onway".equals(analType)) {
					dataset.addAttribute("seriesName", "��;");
				}
				for (Map map : list) {
					Element category = categories.addElement("category");
					category.addAttribute("label", map.get("device_name")
							.toString());
					Element set = dataset.addElement("set");
					if ("sum".equals(analType)) {
						set.addAttribute("value", map.get("sum_num").toString());
					}
					if ("use".equals(analType)) {
						set.addAttribute("value", map.get("use_num").toString());
					}
					if ("scrap".equals(analType)) {
						set.addAttribute("value", map.get("scrap_num")
								.toString());
					}
					if ("idle".equals(analType)) {
						set.addAttribute("value", map.get("idle_num")
								.toString());
					}
					if ("repairing".equals(analType)) {
						set.addAttribute("value", map.get("repairing_num")
								.toString());
					}
					if ("wait_repair".equals(analType)) {
						set.addAttribute("value", map.get("wait_repair_num")
								.toString());
					}
					if ("wait_scrap".equals(analType)) {
						set.addAttribute("value", map.get("wait_scrap_num")
								.toString());
					}
					if ("onway".equals(analType)) {
						set.addAttribute("value", map.get("onway_num")
								.toString());
					}
					String device_code = map.get("device_code").toString();
					if (device_code.startsWith("D002")
							|| device_code.startsWith("D001")
							|| device_code.startsWith("D007")
							|| device_code.startsWith("D003")
							|| device_code.startsWith("D004")
							|| device_code.startsWith("D005")
							|| device_code.startsWith("D006")) {
					 
							if (cLevel <= 4 ) {
								if(cLevel==4){
									wutanorg=	(String) map.get("org_subjection_id")	;
								}
								set.addAttribute("link",
										"JavaScript:popNextLevelAnal('"
												+ device_code + "','"
												+ wutanorg + "','" + ifCountry
												+ "','" + analType + "','"
												+ nLevel + "')");
							} else {
								if (1==1) {//"C105".equals(wutanorg)
									if(cLevel>=4){
										wutanorg=	(String) map.get("org_subjection_id")	;
									}
									String postion_id="";
									if("idle".equals(analType)||"repairing".equals(analType)||"wait_scrap".equals(analType)||"wait_repair".equals(analType)){
										postion_id=(String) map.get("postion_id");
									}
									if("use".equals(analType)){
										if(Integer.parseInt((String)map.get("use_num"))>0){
											set.addAttribute("link",
													"JavaScript:popDevOrgAnal('"
															+ device_code + "','"
															+ ifCountry + "','"
															+ analType + "','"+wutanorg+"','"+postion_id+"')");
										}
									}else{
									set.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"','"+postion_id+"')");
									}
								}
							}
					   
					} else {
						if (1==1) {//"C105".equals(wutanorg)
							if(cLevel==4){
								wutanorg=	(String) map.get("org_subjection_id")	;
							}
							String postion_id="";
							if("idle".equals(analType)||"repairing".equals(analType)||"wait_scrap".equals(analType)||"wait_repair".equals(analType)){
								postion_id=(String) map.get("postion_id");
							}
							if("use".equals(analType)){
								if(Integer.parseInt((String)map.get("use_num"))>0){
									set.addAttribute("link",
											"JavaScript:popDevOrgAnal('"
													+ device_code + "','"
													+ ifCountry + "','"
													+ analType + "','"+wutanorg+"','"+postion_id+"')");
								}
							}else{
							set.addAttribute("link",
									"JavaScript:popDevOrgAnal('"
											+ device_code + "','"
											+ ifCountry + "','"
											+ analType + "','"+wutanorg+"','"+postion_id+"')");
							}
						}
					}
				}
			}

		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	public ISrvMsg getDevOrgChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//λ��
		 String postion_id = isrvmsg.getValue("postion_id");
		 if (StringUtils.isBlank(postion_id)) {
			 postion_id = "";
		 }
		// �ʲ�״̬
		 String account_stat = isrvmsg.getValue("account_stat");
		 if (StringUtils.isBlank(account_stat)) {
			 account_stat = "";
		 }// ��̽��
		String wutanorg = isrvmsg.getValue("wutanorg");
		if (StringUtils.isBlank(wutanorg)) {
			wutanorg = "";
		}
		// ������
		String parentCode = isrvmsg.getValue("parentCode");
		if (StringUtils.isBlank(parentCode)) {
			parentCode = "";
		}
		// ͳ�����
		String analType = isrvmsg.getValue("analType");
		if (StringUtils.isBlank(analType)) {
			analType = "";
		}
		// ���ڹ���
		String ifCountry = isrvmsg.getValue("ifCountry");
		String country = "";
		if (StringUtils.isBlank(ifCountry)) {
			country = "";
		} else {
			if ("in".equals(ifCountry)) {
				country = "����";
			}
			if ("out".equals(ifCountry)) {
				country = "����";
			}
		}
		String other_sql="select count(*) "+analType+"_num,"
				+ "  dev_position_name project_name,position_id,"
				+ "   unit,"
				+ "  '"+parentCode+"' device_code"
				+ "   from (select (select p.pos_name"
				+ "   from gms_device_position p"
				+ "     where acc.position_id = p.pos_id) dev_position_name, acc.position_id,"
				+ "   case"
				+ "     when dt.dev_tree_id like 'D001%' then"
				+ "       '��'"
				+ "      when dt.dev_tree_id like 'D002%' or"
				+ "           dt.dev_tree_id like 'D003%' then"
				+ "       '̨'"
				+ "      when dt.dev_tree_id like 'D005%' then"
				+ "        '��'"
				+ "      when dt.dev_tree_id like 'D004%' or"
				+ "           dt.dev_tree_id like 'D006%' then"
				+ "       '��'"
				+ "      when dt.dev_tree_id like 'D007%' then"
				+ "       '��'"
				+ "    end as unit"
				+ "  from gms_device_account acc"
				+ "  left join dms_device_tree dt"
				+ "     on dt.device_code = acc.dev_type";
				if("idle".equals(analType)){
				other_sql+="   where acc.using_stat = '0110000007000000002'";
				}
				if("repairing".equals(analType)){//����
					other_sql+="   where acc.tech_stat = '0110000006000000007'";
				}
				if("wait_repair".equals(analType)){//����
					other_sql+="   where acc.tech_stat = '0110000006000000006'";
				}
				if("wait_scrap".equals(analType)){//������
					other_sql+="   where acc.tech_stat = '0110000006000000005'";
				}
				other_sql+= "     and acc.account_stat like '"+account_stat+"%'"
				+ "     and dt.dev_tree_id like '"+parentCode+"%'"
				+ "     and acc.owning_sub_id like '"+wutanorg+"%'"
				+ "     and acc.ifcountry = '"+country+"'"    
				+ "     and acc.position_id like '"+postion_id+"%'"
				+ "     and acc.bsflag = '0')"
				+ "  group by position_id, unit,dev_position_name";	 
	StringBuilder sql = new StringBuilder(
			"select t.*,inf.org_abbreviation as org_name from (select tdh.org_subjection_id,"
			+ " sum(nvl(tdh.sum_num,0)) as sum_num,"
			+ " sum(nvl(case when tdh.account_stat != '0110000013000000001' then tdh.use_num end,0)) as use_num,"
			+ " sum(nvl(case when tdh.account_stat = '0110000013000000001' then tdh.use_num end,0)) as scrap_num,"
			+ " sum(nvl(tdh.idle_num,0)) as idle_num,"
			+ " sum(nvl(tdh.repairing_num,0)) as repairing_num,"
			+ " sum(nvl(tdh.wait_repair_num,0)) as wait_repair_num,"
			+ " sum(nvl(tdh.wait_scrap_num,0)) as wait_scrap_num,"
			+ " sum(nvl(tdh.onway_num,0)) as onway_num"
			+ " from dms_device_tree dt"
			+ " inner join ( select * from gms_device_dailyhistory dh"
			+ " where dh.bsflag = '0' and dh.country in ('����','����')");
			if(StringUtils.isNotBlank(account_stat)){
				sql.append(" and  dh.account_stat = '"+account_stat+"' ");
			}
			sql.append( " and dh.his_date=(select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");

		// ���ڹ���
		if (StringUtils.isNotBlank(country)) {
			sql.append(" and dh.country='" + country + "' and dh.org_subjection_id like '"+wutanorg+"%'");
		}
		sql.append(" ) tdh on tdh.device_type = dt.device_code where dt.bsflag='0' and dt.device_code is not null");
		// tree����
		if (StringUtils.isNotBlank(parentCode)) {
			sql.append(" and dt.dev_tree_id like '" + parentCode + "%' ");
		}
		sql.append(" group by tdh.org_subjection_id ) t left join comm_org_subjection sub"
				+ " on t.org_subjection_id=sub.org_subjection_id and sub.bsflag='0'"
				+ " left join comm_org_information inf on sub.org_id=inf.org_id and inf.bsflag='0'");
		List<Map> list =new ArrayList<Map>();
		 
		//list= jdbcDao.queryRecords(sql.toString());
		String user_sql ="select count(*) use_num, project_name, unit from(select acc.dev_name, pro.project_name || '(' || orgsubidtoname(acc.usage_sub_id) || '-' || t.team_id || ')' project_name, acc.project_info_no, case when dt.dev_tree_id like 'D001%' then '��' when dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' then '̨' when dt.dev_tree_id like 'D005%' then '��' when dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%' then '��' when dt.dev_tree_id like 'D007%' then '��' end as unit from gms_device_account acc left join gp_task_project pro on pro.project_info_no = acc.project_info_no left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no left join dms_device_tree dt on dt.device_code = acc.dev_type left join gp_task_project_dynamic d on d.project_info_no = pro.project_info_no left join comm_org_team t on d.org_id = t.org_id where acc.using_stat = '0110000007000000001' and acc.account_stat like '"+account_stat+"%' and pro.bsflag != '1' and dy.bsflag != '1' and ifcountry = '"+country+"' and dt.dev_tree_id like '"+parentCode+"%' and acc.owning_sub_id like '"+wutanorg+"%') tab group by project_info_no, project_name, unit ";
		String dzyquser_Sql = " select project_name, sum(use_num) use_num, unit from(select project_name, use_num, case when '"+parentCode+"' like 'D001%' then '��' when '"+parentCode+"' like 'D002%' or '"+parentCode+"' like 'D003%' then '̨' when '"+parentCode+"' like 'D005%' then '��' when '"+parentCode+"' like 'D004%' or '"+parentCode+"' like 'D006%' then '��' when '"+parentCode+"' like 'D007%' then '��' end as unit from (select pro.project_name, nvl(ci.dev_slot_num*t.unuse_num, 0) + nvl(ci.dev_slot_num*dd.checkingnum, 0) as use_num from gms_device_coll_account_dui t join gms_device_collectinfo ci on t.device_id=ci.device_id left join gp_task_project pro on t.project_info_id = pro.project_info_no left join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_id left join (select det.dev_acc_id, sum(nvl(det.back_num, 0) - nvl(det.checked_num, 0)) as checkingnum from gms_device_collbackapp_detail det left join gms_device_collbackapp app on det.device_backapp_id = app.device_backapp_id where app.state = '9' and app.bsflag = '0' and det.bsflag = '0' and app.backapptype = '4' group by det.dev_acc_id) dd on t.dev_acc_id = dd.dev_acc_id where t.device_id in (select t.device_id from GMS_DEVICE_COLL_ACCOUNT_DUI t left join gms_device_collectinfo info on t.device_id = info.device_id where node_type_id in (select distinct device_code from dms_device_tree dt where dt.dev_tree_id like '"+parentCode+"%') and info.dev_code not like '04%') and dy.org_subjection_id like '"+DevUtil.getCorreSpondOrgSubId(wutanorg)+"%' order by t.actual_in_time desc)) where use_num > 0 group by project_name, unit ";
		String collUser_sql = " select project_name,sum(use_num) use_num ,unit from (select project_name," + "  use_num,"
				+ " case " + "     when '"
				+ parentCode
				+ "' like 'D001%' then "
				+ "     '��' "
				+ "    when '"
				+ parentCode
				+ "' like 'D002%' or '"
				+ parentCode
				+ "' like 'D003%' then "
				+ "     '̨' "
				+ "     when '"
				+ parentCode
				+ "' like 'D005%' then "
				+ "      '��'  "
				+ "    when '"
				+ parentCode
				+ "' like 'D004%' or '"
				+ parentCode
				+ "' like 'D006%' then "
				+ " 				  '��' "
				+ "     when '"
				+ parentCode
				+ "' like 'D007%' then "
				+ "      '��'  "
				+ " 				 end as unit "
				+ " from (select pro.project_name, nvl(t.unuse_num,0)+nvl(checkingnum,0) use_num, info.org_abbreviation "
			 
				+ "    from gms_device_coll_account_dui t"
				+ "    left join gms_device_coll_account acc"
				+ "   on acc.dev_acc_id=t.fk_dev_acc_id"
				+ "    left join gp_task_project pro"
				+ "      on t.project_info_id = pro.project_info_no"
				+ "    left join gp_task_project_dynamic dy"
				+ "      on dy.project_info_no = t.project_info_id"
				+ "    left join comm_org_information info"
				+ "      on info.org_id = dy.org_id"
				+ "    and info.bsflag = '0'"
				+ "   left join comm_org_subjection sub"
				+ "     on sub.org_id = info.org_id"
				+ "    and sub.bsflag = '0'"
				+ " left join (select det.dev_acc_id,"
				+ "          sum(nvl(det.back_num, 0) -"
                + "             nvl(det.checked_num, 0)) as checkingnum"
                + "     from gms_device_collbackapp_detail det"
                + "    left join gms_device_collbackapp app"
                + "       on det.device_backapp_id = app.device_backapp_id"
                + "    where app.state = '9'"
                + "      and app.bsflag = '0'"
                + "      and det.bsflag = '0'"
                + "      and app.backapptype = '4'"
                + "    group by det.dev_acc_id "
                + "    ) dd"
                + " on t.dev_acc_id = dd.dev_acc_id"
				+ "   where t.device_id in"
				+ "         (select i.device_id"
				+ "  from gms_device_coll_account_dui i"
				+ "  left join gms_device_collectinfo info"
				+ "   on i.device_id = info.device_id"
				+ " where info.dev_code in  (select distinct device_code from dms_device_tree dt where     dt.dev_tree_id like '"
				+ parentCode
				+ "%' ))"
				+ "       and dy.org_subjection_id like '"
				+ wutanorg
				+ "%'"
				+ "     and acc.owning_sub_id like '"+wutanorg+"%' "
				
				+ "      order by t.actual_in_time desc) ) where use_num>0 group by project_name,unit"
				+ " union all   (select f.project_info_no,"
				+ "            sum(nvl(m.assign_num, 0)) as use_num,'��' unit"
	            + "            from gms_device_appmix_main m"
	            + "            left join gms_device_mixinfo_form f"
	            + "               on m.device_mixinfo_id = f.device_mixinfo_id"
	            + "            left  join gms_device_coll_account t"
	            + "             on t.dev_acc_id = m.dev_acc_id"
	            + "            where m.state = '0'"
	            + "             and f.state = '1'"
	            + "             and f.bsflag = '0'"
	            + "          and f.mixform_type = '7'"
	            + "              and f.mix_type_id = 'S14050208'"
	            + "             and t.owning_sub_id like '"+wutanorg+"%'"
	            + "           group by m.dev_acc_id, f.project_info_no)     ";
	        


		if ("use".equals(analType)) {
			if (parentCode.startsWith("D005")) {
				list = jdbcDao.queryRecords(collUser_sql.toString());
			} else if (parentCode.startsWith("D001")) {
				list = jdbcDao.queryRecords(dzyquser_Sql.toString());
			} else {
				list = jdbcDao.queryRecords(user_sql.toString());
			}
		}
		if("idle".equals(analType)||"repairing".equals(analType)||"wait_scrap".equals(analType)||"wait_repair".equals(analType)){
			list = jdbcDao.queryRecords(other_sql.toString());
		}
		String pSql = "select case when dt.device_type is not null then dt.device_type else dt.device_name end as device_name,"
				+ " case when dt.dev_tree_id like 'D001%' then '��'  when dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%'  then '̨' "
				+ " when dt.dev_tree_id like 'D005%' then '��'  when dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%'  then '��' when dt.dev_tree_id like 'D007%' then '��' end as unit"
				+ " from dms_device_tree dt where dt.bsflag='0' and dt.dev_tree_id='"
				+ parentCode + "'";
		Map pMap = jdbcDao.queryRecordBySQL(pSql);
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		if (MapUtils.isNotEmpty(pMap) && null != pMap.get("device_name")) {
			root.addAttribute("caption", pMap.get("device_name").toString());
			root.addAttribute("yAxisName", "��λ��" + pMap.get("unit").toString());
		}
		// ��������
		if (CollectionUtils.isNotEmpty(list) && list.size() > 0) {
			if ("".equals(analType)) {
				Element categories = root.addElement("categories");
				Element dataset1 = root.addElement("dataset");
				dataset1.addAttribute("seriesName", "����");
				Element dataset2 = root.addElement("dataset");
				dataset2.addAttribute("seriesName", "���-���ã��������ϣ�");
				Element dataset3 = root.addElement("dataset");
				dataset3.addAttribute("seriesName", "���-���ã������ϣ�");
				Element dataset4 = root.addElement("dataset");
				dataset4.addAttribute("seriesName", "���-����");
				Element dataset5 = root.addElement("dataset");
				dataset5.addAttribute("seriesName", "����");
				Element dataset6 = root.addElement("dataset");
				dataset6.addAttribute("seriesName", "����");
				Element dataset7 = root.addElement("dataset");
				dataset7.addAttribute("seriesName", "������");
				Element dataset8 = root.addElement("dataset");
				dataset8.addAttribute("seriesName", "��;");
				for (Map map : list) {
					Element category = categories.addElement("category");
					category.addAttribute("label", map.get("org_name")
							.toString());
					Element set1 = dataset1.addElement("set");
					set1.addAttribute("value", map.get("sum_num").toString());
					Element set2 = dataset2.addElement("set");
					set2.addAttribute("value", map.get("use_num").toString());
					Element set3 = dataset3.addElement("set");
					set3.addAttribute("value", map.get("scrap_num").toString());
					Element set4 = dataset4.addElement("set");
					set4.addAttribute("value", map.get("idle_num").toString());
					Element set5 = dataset5.addElement("set");
					set5.addAttribute("value", map.get("repairing_num")
							.toString());
					Element set6 = dataset6.addElement("set");
					set6.addAttribute("value", map.get("wait_repair_num")
							.toString());
					Element set7 = dataset7.addElement("set");
					set7.addAttribute("value", map.get("wait_scrap_num")
							.toString());
					Element set8 = dataset8.addElement("set");
					set8.addAttribute("value", map.get("onway_num").toString());
				}
			} else {
				Element categories = root.addElement("categories");
				Element dataset = root.addElement("dataset");
				if ("sum".equals(analType)) {
					dataset.addAttribute("seriesName", "����");
				}
				if ("use".equals(analType)) {
					dataset.addAttribute("seriesName", "���-���ã��������ϣ�");
				}
				if ("scrap".equals(analType)) {
					dataset.addAttribute("seriesName", "���-���ã������ϣ�");
				}
				if ("idle".equals(analType)) {
					dataset.addAttribute("seriesName", "���-����");
				}
				if ("repairing".equals(analType)) {
					dataset.addAttribute("seriesName", "����");
				}
				if ("wait_repair".equals(analType)) {
					dataset.addAttribute("seriesName", "����");
				}
				if ("wait_scrap".equals(analType)) {
					dataset.addAttribute("seriesName", "������");
				}
				if ("onway".equals(analType)) {
					dataset.addAttribute("seriesName", "��;");
				}
				for (Map map : list) {
					Element category = categories.addElement("category");
					category.addAttribute("label", map.get("project_name")
							.toString());
					Element set = dataset.addElement("set");
				
					if ("sum".equals(analType)) {
						set.addAttribute("value", map.get("sum_num").toString());
					} 
					if ("use".equals(analType)) {
						if(wutanorg.startsWith("C105006")){
							set.addAttribute("value", map.get("use_num").toString());
						}else{
							set.addAttribute("value", map.get("use_num").toString());
						}
						 
					}
					if ("scrap".equals(analType)) {
						set.addAttribute("value", map.get("scrap_num")
								.toString());
					}
					if ("idle".equals(analType)) {
						if(wutanorg.startsWith("C105006")){
						set.addAttribute("value", map.get("idle_num")
								.toString());
					}else{
						set.addAttribute("value", map.get("idle_num")
								.toString());
					}
					set.addAttribute("link",  "JavaScript:popIdleList('"+(String)map.get("position_id")+"')");
					}
					if ("repairing".equals(analType)) {
						set.addAttribute("value", map.get("repairing_num")
								.toString());
					}
					if ("wait_repair".equals(analType)) {
						set.addAttribute("value", map.get("wait_repair_num")
								.toString());
					}
					if ("wait_scrap".equals(analType)) {
						set.addAttribute("value", map.get("wait_scrap_num_out")
								.toString());
					}
					if ("onway".equals(analType)) {
						set.addAttribute("value", map.get("onway_num")
								.toString());
					}
				}
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * ά�޶�Ӧ�����й�������
	 * **/
	public ISrvMsg getGzInfoByBywxidForWx(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String bywx_id = msg.getValue("bywx_id");
		// falut_source ������Դ 1ά��2���� falut_case ���Ͻ������ 0�ֳ� 1ά��
		// FALUT_DEAL_FLAG0δ���and falut_deal_flag='0'
		String querysgllSql = "select l.*,t.parent_falut_id,t.falut_name,d.deal_id,d.deal_name from gms_device_zy_falut l "
				+ "left join GMS_DEVICE_ZY_FALUT_CATEGORY t on l.falut_group_id=t.falut_id "
				+ "left join GMS_DEVICE_ZY_FALUT_DEAL d on l.falut_desc = d.deal_id where "
				+ "l.bsflag='0' "
				+ "and ((l.falut_source = '2' and l.falut_case = '1'  and l.falut_deal_flag='0' and l.usemat_id in(select usemat_id  from gms_device_zy_bywx where (dev_acc_id = (select distinct bywx.dev_acc_id from gms_device_zy_bywx bywx where bywx.usemat_id =(select usemat_id from gms_device_zy_bywx bywx where bywx.bywx_id='"
				+ bywx_id
				+ "')) or dev_acc_id =(select bywx.dev_acc_id from gms_device_zy_bywx bywx where bywx.bywx_id='"
				+ bywx_id
				+ "')))) "
				+ "or (l.falut_source = '2' and l.falut_case = '1'  and l.falut_deal_flag='1' and l.falut_deal_id =(select distinct bywx.usemat_id from gms_device_zy_bywx bywx where bywx.usemat_id = (select usemat_id from gms_device_zy_bywx bywx where bywx.bywx_id='"
				+ bywx_id
				+ "'))) "
				+ "or (l.falut_source = '1' and l.usemat_id=(select usemat_id from gms_device_zy_bywx bywx where bywx.bywx_id='"
				+ bywx_id + "')))";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * ��ѯ���������Ŀ����
	 */
	public ISrvMsg getByItemDetailByBywxid(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String bywx_id = isrvmsg.getValue("bywx_id");// �������ʶ
		String sql = " select  d.select_flag as selectFlag,d.item_id as itemId,p.item_name as itemName,p.item_code as itemCode,d.ycbz as ycbz from gms_device_zy_byitem_detail d,gms_device_zy_byitem  p where d.bsflag='0' and d.ITEM_ID=p.ITEM_ID and d.BYWX_ID=(select usemat_id from gms_device_zy_bywx bywx where bywx.bywx_id='"
				+ bywx_id
				+ "') and d.select_flag ='checked' order by p.item_code";
		List<Map> byItemList = jdbcDao.queryRecords(sql);
		if (byItemList != null) {
			responseDTO.setValue("byItemList", byItemList);
		}
		return responseDTO;
	}

	/**
	 * NEWMETHOD �����������ԭ��
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveGzFalutDeal(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// ��Ŀ���
		String projectInfoNo = user.getProjectInfoNo();
		String falut_group_id = msg.getValue("falut_group_id");
		String falut_desc_name = msg.getValue("falut_desc_name");
		String falut_desc_id = "";
		// �洢
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("FALUT_ID", falut_group_id);
		dataMap.put("DEAL_NAME", falut_desc_name);
		dataMap.put("bsflag", "0");
		falut_desc_id = jdbcDao.saveOrUpdateEntity(dataMap,
				"GMS_DEVICE_ZY_FALUT_DEAL").toString();
		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("falut_desc_id", falut_desc_id);
		return responseDTO;
	}

	/**
	 * ��ѯ�����з��ֵ�δ����Ĺ�������
	 * update by zjb 
	 * @since 2016-12-6 10:58:01
	 * 
	 */
	public ISrvMsg getBygzList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String bywx_id = isrvmsg.getValue("bywx_id");// �������ʶ
		String sql = "select count(t.dev_acc_id) counts,t.dev_acc_id,dui.self_num,dui.dev_sign from (select bywx.dev_acc_id,f.bsflag,f.falut_source,f.falut_case,f.falut_deal_flag from GMS_DEVICE_ZY_BYWX bywx, GMS_DEVICE_ZY_FALUT f where bywx.usemat_id = f.usemat_id) t left join gms_device_account_dui dui on t.dev_acc_id = dui.dev_acc_id "
				+ "where t.falut_deal_flag='0' and t.bsflag = '0' and t.falut_source='2' and t.falut_case= '1'  and t.dev_acc_id is not null group by t.dev_acc_id,dui.self_num,dui.dev_sign";
		List<Map> bygzList = jdbcDao.queryRecords(sql);
		if (bygzList != null) {
			responseDTO.setValue("bygzList", bygzList);
		}
		return responseDTO;
	}

	/**
	 * ��ѯ�ɿ���Դ��Ŀ��Ϣ *
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getbyItemInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String dev_ci_code = msg.getValue("dev_ci_code");
		String querysgllSql = "select * from Gms_Device_Zy_Byitem_kkzy kkzy where kkzy.dev_ci_code = '"
				+ dev_ci_code + "'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * �����Ա�Ų�ѯ���¹���Сʱ��
	 * **/
	public ISrvMsg getWorkHourBySelf(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String self_num = msg.getValue("self_num");
		String queryBySql = "select t.self_num,t.dev_acc_id,(select to_char(max(to_number(work_hours))) from (select work_hours, kk.dev_acc_id from gms_device_zy_bywx kk,(select dev_acc_id, max(bywx_date) as bywx_date from gms_device_zy_bywx where bsflag = '0' and bywx_type = '2' group by dev_acc_id) k where kk.dev_acc_id = k.dev_acc_id and kk.bywx_type = '2' and kk.bywx_date = k.bywx_date) s where s.dev_acc_id = t.dev_acc_id) as hours from gms_device_account_dui t where t.self_num='"
				+ self_num + "' ";
		Map map = jdbcDao.queryRecordBySQL(queryBySql);
		responseDTO.setValue("datas", map);
		return responseDTO;
	}

	/**
	 * ��������ҳ���ѯ��ѡ�еı������������ֵ���Ŀ������Ŀ
	 **/
	public ISrvMsg getSelwxbyMatInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String gz_bj_id = msg.getValue("gz_bj_id");
		if (gz_bj_id == null) {
			gz_bj_id = "";
		}
		String querysgllSql = "select * from gms_device_zy_wxbymat g left join "
				+ "(select i.*, c.code_name,tt.postion, tt.stock_num,tt.actual_price,tt.wz_sequence from (select  t.wz_id,t.wz_sequence,t.stock_num, t.actual_price,t.postion  from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'   and wz_sequence is  null and t.project_info_id is null "
				+ ") tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0' ) on tt.wz_id=i.wz_id "
				+ "order by tt.postion asc,i.coding_code_id asc ,i.wz_id asc) p "
				+ "on p.wz_id = g.wz_id where g.bsflag=0 and "
				+ "g.gz_bj_id ='"
				+ gz_bj_id
				+ "'";

		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ѯ��Դ���������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRecyclematInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String idinfo = msg.getValue("idinfo");
		StringBuffer sb = new StringBuffer()
			.append("select * from (select t.alias,t.recyclemat_info,t.wz_sequence,t.wz_id,i.wz_name,i.wz_prickie,i.wz_price,t.actual_price,c.code_name,i.coding_code_id,t.postion,t.stock_num"
					+ " from gms_mat_recyclemat_info t "
					+ " inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id "
					+ " where t.bsflag='0'and t.wz_type='3' and t.project_info_id is null and t.wz_id not like '%zy%' and t.recyclemat_info ='"+idinfo+"') tmp where 1=1 ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (mainMap != null) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * ��ȡά��ͳ�ƻ���sql
	 * @return  
	 */
	public String getRepairAnalBasicSql(){
		String sql = " select nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) as repair_cost,"
				+ " case when ri.repair_level='605' then 'baoyang'"
				+ " else 'weixiu' end as repair_type,"
				+ " ri.repair_start_date as repair_date, "
				+ " 'xcwx' data_type,"
				+ " dui.dev_type,"
				+ " acc.ifcountry,"
				+ " dui.dev_name,"
				+ " dui.dev_model,"
				+ " dui.self_num,"
				+ " dui.license_num,"
				+ " dui.dev_sign,"
				+ " nvl(dui.asset_value,0) as asset_value,"
				+ " nvl(dui.net_value,0) as net_value,"
				+ " ri.project_info_no,"
				+ " case when dui.owning_sub_id like 'C105001%' then"
				+ " substr(dui.owning_sub_id, 1, 10) when dui.owning_sub_id like 'C105005%' then"
				+ " substr(dui.owning_sub_id, 1, 10) else substr(dui.owning_sub_id, 1, 7) end as sub_id"
				+ " from bgp_comm_device_repair_info ri "
				+ " left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0' "
				+ " left join gms_device_account acc on dui.fk_dev_acc_id=acc.dev_acc_id and acc.bsflag='0' "
				+ " where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no is not null "
				+ " union all"
				+ " select nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) as repair_cost,"
				+ " case when ri.repair_level='605' then 'baoyang'"
				+ " else 'weixiu' end as repair_type,"
				+ " ri.repair_start_date as repair_date,"
				+ " 'fxcwx' data_type,"
				+ " acc.dev_type,"
				+ " acc.ifcountry,"
				+ " acc.dev_name,"
				+ " acc.dev_model,"
				+ " acc.self_num,"
				+ " acc.license_num,"
				+ " acc.dev_sign,"
				+ " nvl(acc.asset_value,0) as asset_value,"
				+ " nvl(acc.net_value,0) as net_value,"
				+ " '' as project_info_no,"
				+ " case when acc.owning_sub_id like 'C105001%' then substr(acc.owning_sub_id, 1, 10)"
				+ " when acc.owning_sub_id like 'C105005%' then substr(acc.owning_sub_id, 1, 10) else substr(acc.owning_sub_id, 1, 7) end as sub_id"
				+ " from bgp_comm_device_repair_info ri"
				+ " left join gms_device_account acc on ri.device_account_id = acc.dev_acc_id and acc.bsflag = '0'"
				+ " where ri.bsflag = '0' and ( ri.datafrom ='SAP' or ( ri.datafrom is null and ri.project_info_no is null ))"
				+ " union all"
				+ " select nvl(m.use_num, 0) * nvl(r.actual_price, 0) as repair_cost,"
				+ " case when t.maintenance_level='��' then 'weixiu' else 'baoyang' end as repair_type,"
				+ " t.bywx_date as repair_date,"
				+ " 'fxcwx' data_type,"
				+ " acc.dev_type,"
				+ " acc.ifcountry,"
				+ " acc.dev_name,"
				+ " acc.dev_model,"
				+ " acc.self_num,"
				+ " acc.license_num,"
				+ " acc.dev_sign,"
				+ " nvl(acc.asset_value,0) as asset_value,"
				+ " nvl(acc.net_value,0) as net_value,"
				+ " '' as project_info_no,"
				+ " t.org_subjection_id as sub_id"
				+ " from gms_device_zy_bywx t"
				+ " left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id"
				+ " left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id"
				+ " left join gms_device_account acc on t.dev_acc_id=acc.dev_acc_id and acc.bsflag = '0' "
				+ " where t.project_info_id is null and r.wz_type = '3' and r.bsflag = '0' and r.project_info_id is null and t.bsflag = '0'"
				+ " union all"
				+ " select nvl(m.use_num, 0) * nvl(r.actual_price, 0) as repair_cost,"
				+ " case when t.maintenance_level='��' then 'weixiu' else 'baoyang' end as repair_type,"
				+ " t.bywx_date as repair_date,"
				+ " 'xcwx' data_type,"
				+ " dui.dev_type,"
				+ " acc.ifcountry,"
				+ " dui.dev_name,"
				+ " dui.dev_model,"
				+ " dui.self_num,"
				+ " dui.license_num,"
				+ " dui.dev_sign,"
				+ " nvl(dui.asset_value,0) as asset_value,"
				+ " nvl(dui.net_value,0) as net_value,"
				+ " t.project_info_id as project_info_no,"
				+ " t.org_subjection_id as sub_id"
				+ " from gms_device_zy_bywx t"
				+ " left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id"
				+ " left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id"
				+ " left join gms_device_account_dui dui on t.dev_acc_id=dui.dev_acc_id and dui.bsflag = '0'"
				+ " left join gms_device_account acc on dui.fk_dev_acc_id=acc.dev_acc_id and acc.bsflag='0' "
				+ " where t.bsflag = '0' and r.project_info_id = t.project_info_id";
		return sql;
	}
	/**
	 * ��ȡ����ͳ�ƻ���sql
	 * @return  
	 */
	public String getSpareAnalBasicSql(){
		String sql = " select inf.coding_code_id as mat_code," 
				+ " inf.wz_name as mat_name, " 
				+ " nvl(rd.material_amout, 0) as mat_num,"
				+ " nvl(rd.unit_price, 0) as mat_price,"
				+ " nvl(rd.total_charge, 0) as mat_money,"
				+ " ri.repair_start_date as mat_date, "
				+ " case when dui.owning_sub_id like 'C105001%' then"
				+ " substr(dui.owning_sub_id, 1, 10) when dui.owning_sub_id like 'C105005%' then"
				+ " substr(dui.owning_sub_id, 1, 10) else substr(dui.owning_sub_id, 1, 7) end as sub_id"
				+ " from bgp_comm_device_repair_info ri "
				+ " left join bgp_comm_device_repair_detail rd on ri.repair_info = rd.repair_info and rd.bsflag = '0'"
				+ " left join gms_mat_infomation inf on inf.wz_id = rd.material_coding and inf.bsflag = '0'"
				+ " left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0' "
				+ " where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no is not null "
				+ " union all"
				+ " select rd.material_type as mat_code,"
				+ " rd.material_name as mat_name,"
				+ " nvl(rd.material_amout, 0) as mat_num,"
				+ " nvl(rd.unit_price, 0) as mat_price,"
				+ " nvl(rd.total_charge, 0) as mat_money,"
				+ " ri.repair_start_date as mat_date,"
				+ " case when acc.owning_sub_id like 'C105001%' then substr(acc.owning_sub_id, 1, 10)"
				+ " when acc.owning_sub_id like 'C105005%' then substr(acc.owning_sub_id, 1, 10) else substr(acc.owning_sub_id, 1, 7) end as sub_id"
				+ " from bgp_comm_device_repair_info ri"
				+ " left join bgp_comm_device_repair_detail rd on ri.repair_info = rd.repair_info and rd.bsflag = '0'"
				+ " left join gms_device_account acc on ri.dev_code = acc.dev_acc_id and acc.bsflag = '0'"
				+ " where ri.bsflag = '0' and ( ri.datafrom ='SAP' or ( ri.datafrom is null and ri.project_info_no is null ))"
				+ " union all"
				+ " select inf.coding_code_id as mat_code,"
				+ " inf.wz_name as mat_name,"
				+ " nvl(m.use_num,0) as mat_num,"
				+ " nvl(r.actual_price,0) as mat_price,"
				+ " nvl(m.use_num,0)*nvl(r.actual_price,0) as mat_money,"
				+ " t.bywx_date as mat_date,"
				+ " t.org_subjection_id as sub_id"
				+ " from gms_device_zy_bywx t"
				+ " left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id"
				+ " left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id"
				+ " left join gms_mat_infomation inf on r.wz_id=inf.wz_id"
				+ " where t.project_info_id is null and r.wz_type = '3' and r.bsflag = '0' and r.project_info_id is null and t.bsflag = '0'"
				+ " union all"
				+ " select inf.coding_code_id as mat_code,"
				+ " inf.wz_name as mat_name,"
				+ " nvl(m.use_num,0) as mat_num,"
				+ " nvl(r.actual_price,0) as mat_price,"
				+ " nvl(m.use_num,0)*nvl(r.actual_price,0) as mat_money,"
				+ " t.bywx_date as mat_date,"
				+ " t.org_subjection_id as sub_id"
				+ " from gms_device_zy_bywx t"
				+ " left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id"
				+ " left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id"
				+ " left join gms_mat_infomation inf on r.wz_id=inf.wz_id"
				+ " where t.bsflag = '0' and r.project_info_id = t.project_info_id";
		return sql;
	}
	
}
