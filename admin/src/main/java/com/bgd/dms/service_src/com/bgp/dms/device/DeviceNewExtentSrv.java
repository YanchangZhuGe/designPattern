package com.bgp.dms.device;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * ��ȡ�豸�¶�ϵ��ͼ��
 * @author wangzheqin 2015.3.26
 *
 */
public class DeviceNewExtentSrv extends BaseService{
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();

	public  DeviceNewExtentSrv(){
		log = LogFactory.getLogger(DeviceNewExtentSrv.class);
	}
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	/**
	 * ȡ���¶�ϵ��ͼ������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getNewExtent(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// ��̽��
		String orgSubId = reqDTO.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
		String vcountry="";
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		String ifproduction = reqDTO.getValue("ifproduction");
		//Ĭ������
		if(StringUtils.isBlank(ifproduction)){
			ifproduction = "5110000186000000001";
		}
		
		StringBuilder sql = new StringBuilder(
				"select t.*, d.device_name as label"
						+ " from (select substr(dt.dev_tree_id, 1, "+subStrLength+") dev_tree_id,"
						+ " round(nvl(decode(sum(dh.original_value),0,0,sum(dh.net_value) / sum(dh.original_value)),0),4)*100 as newrate,"
						+ " sum(case when dh.his_date = (select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0') then"
						+ " dh.sum_num else 0 end) as sum_day_num,max(dh.his_date) as hisdate "
						+ " from dms_device_tree dt"
						+ " left join gms_device_dailyhistory dh"
						+ " on dh.device_type = dt.device_code"
						+ " and dh.bsflag = '0' and account_stat='0110000013000000003' ");
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id like'"+orgSubId+"%'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and dh.country='"+vcountry+"'");
		}
		// �����豸
		if(StringUtils.isNotBlank(ifproduction)){
			sql.append(" and dh.ifproduction='"+ifproduction+"'");
		}
		sql.append(" where dt.bsflag = '0'");
		// tree����
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
		}
		sql.append(" group by substr(dt.dev_tree_id, 1, "+subStrLength+")) t left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id order by d.code_order");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numbersuffix", "%");

		int cLevel=Integer.parseInt(level);//��ǰ��ȡ����
		int nLevel=cLevel+1;//��һ��ȡ����
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String sumDayNum=map.get("sum_day_num").toString();//��ǰ��������
				String cdevTreeId=map.get("dev_tree_id").toString();//��ǰdev_tree_id����
				String value = "0";//Ĭ�������
				if(cdevTreeId.startsWith("D001")||cdevTreeId.startsWith("D005")){
					sumDayNum+="��";
				}
				if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
					sumDayNum+="̨";
				}
				set.addAttribute("label", map.get("label").toString()+"("+sumDayNum+")");
				if(null!=map.get("newrate") && !"0".equals(map.get("newrate").toString())){
					value=map.get("newrate").toString();
					//��������������ֻ��ȡ��һ��
					if(cdevTreeId.startsWith("D001")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popNextLevelNewExtent('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+ifproduction+"')");
						}
					}
					//�첨��������ֻ��ȡ������
					if(cdevTreeId.startsWith("D005")){
						// �첨�� ���¼첨����������ȡ
						if(cdevTreeId.startsWith("D005003")){
							if(cLevel<=1){
								set.addAttribute("link", "JavaScript:popNextLevelNewExtent('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+ifproduction+"')");
							}
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelNewExtent('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+ifproduction+"')");
							}
						}
					}
					//�ɿ���Դ,���,�����豸,�����ʾ��ϸ��Ϣ
					if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// �����豸 �����������䳵,ֱ��չ���б�����
						if(cdevTreeId.startsWith("D004003")){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+ifproduction+"')");
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelNewExtent('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+ifproduction+"')");
							}else{
								set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+ifproduction+"')");
							}
						}
					}
					//������������ֻ��ȡ��һ��
					if(cdevTreeId.startsWith("D006")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+ifproduction+"')");
						}
					}
				}
				set.addAttribute("value", value);
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	} 
	
	/**
	 * ��ѯ�豸��Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDevList");		
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
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		//String currentDate=getCurrentDate();
		String devTreeId = isrvmsg.getValue("devTreeId");//  tree����
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		String country = isrvmsg.getValue("country");// ����/����
		String ifproduction = isrvmsg.getValue("ifproduction");//�Ƿ������豸
		String vcountry="";
		if(StringUtils.isNotBlank(country)){
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		StringBuilder sql = new StringBuilder(
				"select t.device_code,t.newrate,t.sum_day_num,d.device_name,d.device_type, cur_date from ( "
						+ " select dt.device_code,nvl(round(decode(sum(dh.original_value),0,0,sum(dh.net_value)*100 / sum(dh.original_value)),2),0) as newrate,"
						+ " sum(case when dh.his_date = (select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0') then"
						+ " dh.sum_num else 0 end) as sum_day_num,max(dh.his_date) as cur_date"
						+ " from dms_device_tree dt"
						+ " inner join gms_device_dailyhistory dh"
						+ " on dh.device_type = dt.device_code"
						+ " and dh.bsflag = '0'");
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and dh.country='"+vcountry+"'");
		}
		sql.append(" where dt.bsflag = '0' and dt.device_code is not null ");
		// tree����
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%'");
		}
		// �����豸
		if(StringUtils.isNotBlank(ifproduction)){
			sql.append(" and dh.ifproduction ='"+ifproduction+"'");
		}
		sql.append(" group by dt.device_code) t left join dms_device_tree d on t.device_code = d.device_code order by d.code_order");

		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	
	/**
	 * ��ȡ��ǰ���
	 * 
	 * @return
	 */
	public String getCurrentYear() {
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		return year.toString();
	}

	
	/**
	 * ��ȡ��ǰʱ��
	 * 
	 * @return
	 */
	public String getCurrentDate() {
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd");
		return dateFormat.format(now);
	}
}
