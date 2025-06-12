package com.bgp.dms.plan;

import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.bgp.dms.util.BigScreenUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * @ClassName: DeviceStockSrv
 * @Description:�豸����ͳ�Ʒ�������
 * @author dushuai
 * @date 2015-3-18
 */
public class DeviceStockSrv extends BaseService {
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	public DeviceStockSrv() {
		log = LogFactory.getLogger(DeviceStockSrv.class);
	}

	/**
	 * ��ȡ����ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getStockChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ���ڹ���
		String country = isrvmsg.getValue("country");
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				country="����";
			}
			if("2".equals(country)){
				country="����";			
			}
		}
		// ����
		String code = isrvmsg.getValue("code");
		if(StringUtils.isBlank(code)){
			code="";
		}
		String display=isrvmsg.getValue("display");//��ʾ
		StringBuilder sql = new StringBuilder(
				"select substr(dt.dev_tree_id, 1, 4) as device_code,"
						+ " sum(nvl(dh.use_num,0)) as use_num,"
						+ " sum(nvl(dh.idle_num,0)) as idle_num,"
						+ " sum(nvl(dh.repairing_num ,0)+nvl(dh.wait_repair_num,0)) as repaire_num,"
						+ " sum(nvl(dh.wait_scrap_num,0)) as wait_scrap_num,"
						+ " sum(nvl(dh.sum_num,0)-nvl(dh.idle_num,0)-nvl(dh.use_num,0)) as other_num"
						+ " from gms_device_dailyhistory dh"
						+ " left join dms_device_tree dt on dh.device_type = dt.device_code and dt.bsflag='0' and dt.device_code is not null"
					    + " where dh.bsflag = '0' and dh.account_stat='0110000013000000003' and dh.his_date=(select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(country)){
			sql.append(" and dh.country = '"+country+"'");
		}
		// ����
		if(StringUtils.isNotBlank(code)){
			sql.append(" and dt.dev_tree_id like '"+code+"%'");
		}	
		sql.append(" group by substr(dt.dev_tree_id, 1,4)");
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		//��������Ϊ΢���źڣ���С20
		if(null!=display && "bigScreen".equals(display)){
			root.addAttribute("baseFont", BigScreenUtil.BIG_SCREEN_FONT_FAMILY);
			root.addAttribute("baseFontSize", BigScreenUtil.BIG_SCREEN_FONT_SIZE);
		}else{
			root.addAttribute("baseFontSize", "12");
		}
		// ��������
		if(MapUtils.isNotEmpty(map)) {
			Element set1 = root.addElement("set");
			set1.addAttribute("label", "����");
			set1.addAttribute("value", map.get("idle_num").toString());
			setElementDisplayValue(display,code,set1,"����, "+map.get("idle_num").toString());
			Element set2 = root.addElement("set");
			set2.addAttribute("label", "����");
			set2.addAttribute("value", map.get("use_num").toString());
			setElementDisplayValue(display,code,set2,"����, "+map.get("use_num").toString());
			Element set3 = root.addElement("set");
			set3.addAttribute("label", "������");
			set3.addAttribute("value", map.get("wait_scrap_num").toString());
			setElementDisplayValue(display,code,set3,"������, "+map.get("wait_scrap_num").toString());
			Element set4 = root.addElement("set");
			set4.addAttribute("label", "ά��");
			set4.addAttribute("value", map.get("repaire_num").toString());
			setElementDisplayValue(display,code,set4,"ά��, "+map.get("repaire_num").toString());
			Element set5 = root.addElement("set");
			set5.addAttribute("label", "����");
			set5.addAttribute("value", map.get("other_num").toString());
			setElementDisplayValue(display,code,set5,"����, "+map.get("other_num").toString());
		}else{
			Element set1 = root.addElement("set");
			set1.addAttribute("label", "����");
			set1.addAttribute("value", "0");
			setElementDisplayValue(display,code,set1,"����, 0");
			Element set2 = root.addElement("set");
			set2.addAttribute("label", "����");
			set2.addAttribute("value", "0");
			setElementDisplayValue(display,code,set2,"����, 0");
			Element set3 = root.addElement("set");
			set3.addAttribute("label", "������");
			set3.addAttribute("value", "0");
			setElementDisplayValue(display,code,set3,"������, 0");
			Element set4 = root.addElement("set");
			set4.addAttribute("label", "ά��");
			set4.addAttribute("value", "0");
			setElementDisplayValue(display,code,set4,"ά��, 0");
			Element set5 = root.addElement("set");
			set5.addAttribute("label", "����");
			set5.addAttribute("value", "0");
			setElementDisplayValue(display,code,set5,"����, 0");
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	//�����豸��ʾ������λ��ֻ��Ե��������ͼ첨����
	public void setElementDisplayValue(String chartDisplay,String code,Element element,String displayName){
		//�Ǵ�����ʾ�豸������λ����������ʾ�豸������λ
		if(null==chartDisplay || (!"bigScreen".equals(chartDisplay))){
			//��������
			if("D001".equals(code)){
				element.addAttribute("displayValue", displayName+"��");
			}
			//�첨��
			if("D005".equals(code)){
				element.addAttribute("displayValue", displayName+"��");
			}
		}
	}

	/**
	 * ��ȡ������������ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDzyqStockChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuilder sql = new StringBuilder(
				"select round(sum(nvl(acc.total_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as total_num,"
						+ " round(sum(nvl(acc.unuse_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as unuse_num,"
						+ " round(sum(nvl(acc.use_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as use_num,"
						+ " round(sum(nvl(te.touseless_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as touseless_num,"
						+ " round(sum(nvl(te.torepair_num, 0) * nvl(ms.device_slot_num, 0) +"
						+ " nvl(te.repairing_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as repair_num,"
						+ " round(sum(nvl(te.tocheck_num, 0) * nvl(ms.device_slot_num, 0) +"
						+ " nvl(te.destroy_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as other_num"
						+ " from gms_device_coll_account acc"
						+ " left join gms_device_coll_account_tech te on te.dev_acc_id = acc.dev_acc_id"
						+ " left join gms_device_collectinfo info on info.device_id = acc.device_id"
						+ " left join (select distinct su.device_id,su.device_name,su.device_model,su.device_slot_num"
						+ " from gms_device_collmodel_sub su left join gms_device_collmodel_main ma on su.model_mainid = ma.model_mainid"
						+ " where ma.bsflag = '0') ms on ms.device_id = acc.device_id"
						+ " where (info.dev_code like '01%' or info.dev_code like '02%' or info.dev_code like '03%' or info.dev_code like '05%') and acc.bsflag = '0'");
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "2");
		root.addAttribute("baseFontSize", "12");
		// ��������
		Element set1 = root.addElement("set");
		set1.addAttribute("label", "����");
		set1.addAttribute("value", map.get("unuse_num").toString());
		set1.addAttribute("displayValue", "����, "+map.get("unuse_num").toString()+"���");
		Element set2 = root.addElement("set");
		set2.addAttribute("label", "����");
		set2.addAttribute("value", map.get("use_num").toString());
		set2.addAttribute("displayValue", "����, "+map.get("use_num").toString()+"���");
		Element set3 = root.addElement("set");
		set3.addAttribute("label", "������");
		set3.addAttribute("value", map.get("touseless_num").toString());
		set3.addAttribute("displayValue", "������, "+map.get("touseless_num").toString()+"���");
		Element set4 = root.addElement("set");
		set4.addAttribute("label", "ά��");
		set4.addAttribute("value", map.get("repair_num").toString());
		set4.addAttribute("displayValue", "ά��, "+map.get("repair_num").toString()+"���");
		Element set5 = root.addElement("set");
		set5.addAttribute("label", "����");
		set5.addAttribute("value", map.get("other_num").toString());
		set5.addAttribute("displayValue", "����, "+map.get("other_num").toString()+"���");
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ȡ�첨������ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getJbqStockChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuilder sql = new StringBuilder(
				"select sum(nvl(acc.total_num, 0)) as total_num,"
						+ " sum(nvl(acc.unuse_num, 0)) as unuse_num,"
						+ " sum(nvl(acc.use_num, 0)) as use_num,"
						+ " sum(nvl(te.touseless_num, 0)) as touseless_num,"
						+ " sum(nvl(te.torepair_num, 0) +nvl(te.repairing_num, 0)) as repair_num,"
						+ " sum(nvl(te.tocheck_num, 0) +nvl(te.destroy_num, 0) ) as other_num"
						+ " from gms_device_coll_account acc"
						+ " left join gms_device_coll_account_tech te"
						+ " on te.dev_acc_id = acc.dev_acc_id"
						+ " left join gms_device_collectinfo info"
						+ " on info.device_id = acc.device_id"
						+ " where info.dev_code like '04%'"
						+ " and acc.bsflag = '0'");
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// ��������
		Element set1 = root.addElement("set");
		set1.addAttribute("label", "����");
		set1.addAttribute("value", map.get("unuse_num").toString());
		set1.addAttribute("displayValue", "����, "+map.get("unuse_num").toString()+"��");
		Element set2 = root.addElement("set");
		set2.addAttribute("label", "����");
		set2.addAttribute("value", map.get("use_num").toString());
		set2.addAttribute("displayValue", "����, "+map.get("use_num").toString()+"��");
		Element set3 = root.addElement("set");
		set3.addAttribute("label", "������");
		set3.addAttribute("value", map.get("touseless_num").toString());
		set3.addAttribute("displayValue", "������, "+map.get("touseless_num").toString()+"��");
		Element set4 = root.addElement("set");
		set4.addAttribute("label", "ά��");
		set4.addAttribute("value", map.get("repair_num").toString());
		set4.addAttribute("displayValue", "ά��, "+map.get("repair_num").toString()+"��");
		Element set5 = root.addElement("set");
		set5.addAttribute("label", "����");
		set5.addAttribute("value", map.get("other_num").toString());
		set5.addAttribute("displayValue", "����, "+map.get("other_num").toString()+"��");
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
}
