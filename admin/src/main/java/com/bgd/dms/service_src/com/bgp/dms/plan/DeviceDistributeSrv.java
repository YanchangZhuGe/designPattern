package com.bgp.dms.plan;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
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
 * @author wangzheqin 2015.4.9
 *
 */
public class DeviceDistributeSrv extends BaseService{
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	public DeviceDistributeSrv(){
		log = LogFactory.getLogger(DeviceDistributeSrv.class);
	}	
	
	/**
	 * 取得设备分布
	 * @param reqDTO
	 * @return
	 */
	public ISrvMsg getVibroseis(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		//是否生产设备
		String prFlag = reqDTO.getValue("prFlag");
		if(prFlag == null){
			prFlag = "5110000186000000001";
		}
		//在帐不在帐
		String accountStat = reqDTO.getValue("accountStat");
		if(accountStat == null){
			accountStat = "0110000013000000003";
		}
		//设备类型
		String devType = reqDTO.getValue("devType");
		String display=reqDTO.getValue("display");//显示
		StringBuffer sb = new StringBuffer();
		sb.append("select tt.org_sub_id,i.org_abbreviation as label,count(*) as rate from ( ")
		  .append("select case when (t.owning_sub_id like 'C105001%' or t.owning_sub_id like 'C105005%') then substr(t.owning_sub_id,0,10) ")
		  .append("else substr(t.owning_sub_id,0,7) end as org_sub_id ")
		  .append("from gms_device_account t  where 1=1 ");
		if(StringUtils.isNotBlank(accountStat)){
			sb.append("and t.account_stat = '0110000013000000003' ");
		}
		if(StringUtils.isNotBlank(prFlag)){
			sb.append("and t.ifproduction = '5110000186000000001' ");
		}
		sb.append("and (t.owning_sub_id like 'C105002%' or t.owning_sub_id like 'C105001005%' or ")
		  .append("t.owning_sub_id like 'C105001002%' or t.owning_sub_id like 'C105001003%' or ")
		  .append("t.owning_sub_id like 'C105001004%' or t.owning_sub_id like 'C105005004%' or ")
		  .append("t.owning_sub_id like 'C105005000%' or t.owning_sub_id like 'C105005001%' or ")
		  .append("t.owning_sub_id like 'C105007%' or t.owning_sub_id like 'C105063%' or ")
		  .append("t.owning_sub_id like 'C105087%' or t.owning_sub_id like 'C105092%' or ")
		  .append("t.owning_sub_id like 'C105093%' or t.owning_sub_id like 'C105006%' ) and t.dev_type in ")
		  .append("(select t.device_code from dms_device_tree t where t.bsflag ='0' and t.device_code is not null ")
		  .append("start with t.dev_tree_id='").append(devType).append("' ").append("connect by prior t.dev_tree_id = t.father_id) ")
		  .append(") tt left join comm_org_subjection s on s.org_subjection_id= tt.org_sub_id and s.bsflag = '0' ")
		  .append("left join comm_org_information i on i.org_id = s.org_id and i.bsflag = '0' ")
		  .append("group by tt.org_sub_id,i.org_abbreviation order by rate,tt.org_sub_id desc");
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		//大屏字体为微软雅黑，大小20
		if(null!=display && "bigScreen".equals(display)){
			root.addAttribute("baseFont", BigScreenUtil.BIG_SCREEN_FONT_FAMILY);
			root.addAttribute("baseFontSize", BigScreenUtil.BIG_SCREEN_FONT_SIZE);
		}else{
			root.addAttribute("baseFontSize", "12");
		}
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
			int size = list.size();
			for (int i = size - 1; i > -1; i--) {
				Element set = root.addElement("set");
				Map map = list.get(i);
				//大屏不显示数量单位，label名称和别的系统统一
				if(null!=display && "bigScreen".equals(display)){
					String kOrgSubId=map.get("org_sub_id").toString();
					set.addAttribute("label", BigScreenUtil.BIG_SCREEN_ORG_ABBREVIATION.get(kOrgSubId));
					set.addAttribute("displayValue", map.get("rate").toString());
				}else{
					set.addAttribute("label", map.get("label").toString());
					set.addAttribute("displayValue", map.get("rate").toString()+"台");
				}
				set.addAttribute("value", map.get("rate").toString());
				
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 野外采集单位资产原值占比
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceFieldCapital(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =  SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer();
		sb.append("select tt.label,round(sum(tt.asset_value)/100000000,2) as asset_value ,round(ratio_to_report(sum(ASSET_VALUE)) over(),4)*100 as rate ")
		  .append("from ((select i.org_abbreviation as label,sum(ASSET_VALUE) as asset_value from ( ")
		  .append("select case when (t.owning_sub_id like 'C105001%' or t.owning_sub_id like 'C105005%') then substr(t.owning_sub_id,0,10) ")
		  .append("else substr(t.owning_sub_id,0,7) end as org_sub_id,t.ASSET_VALUE ")
		  .append("from gms_device_account t  where  t.bsflag='0' and t.account_stat='0110000013000000003' and ")
		  .append("(t.owning_sub_id like 'C105002%' or t.owning_sub_id like 'C105001005%' or ")
		  .append("t.owning_sub_id like 'C105001002%' or t.owning_sub_id like 'C105001003%' or ")
		  .append("t.owning_sub_id like 'C105001004%' or t.owning_sub_id like 'C105005004%' or ")
		  .append("t.owning_sub_id like 'C105005000%' or t.owning_sub_id like 'C105005001%' or ")
		  .append("t.owning_sub_id like 'C105007%' or t.owning_sub_id like 'C105063%' or ")
		  .append("t.owning_sub_id like 'C105086%' or t.owning_sub_id like 'C105008%' or ")
		  .append("t.owning_sub_id like 'C105087%' or t.owning_sub_id like 'C105092%' or ")
		  .append("t.owning_sub_id like 'C105093%' ) ")
		  .append(") tt left join comm_org_subjection s on s.org_subjection_id= tt.org_sub_id and s.bsflag = '0' ")
		  .append("left join comm_org_information i on i.org_id = s.org_id and i.bsflag = '0' ")
		  .append("group by tt.org_sub_id,i.org_abbreviation ) union all ")
		  .append("(select i.org_abbreviation as label,sum(ASSET_VALUE) as asset_value from ( ")
		  .append("select case when (t.owning_sub_id like 'C105001%' or t.owning_sub_id like 'C105005%') then substr(t.owning_sub_id,0,10) ")
		  .append("else substr(t.owning_sub_id,0,7) end as org_sub_id,t.ASSET_VALUE ")
		  .append("from gms_device_account_b t  where t.bsflag='0' and  t.account_stat='0110000013000000003' and ")
		  .append("(t.owning_sub_id like 'C105002%' or t.owning_sub_id like 'C105001005%' or ")
		  .append("t.owning_sub_id like 'C105001002%' or t.owning_sub_id like 'C105001003%' or ")
		  .append("t.owning_sub_id like 'C105001004%' or t.owning_sub_id like 'C105005004%' or ")
		  .append("t.owning_sub_id like 'C105005000%' or t.owning_sub_id like 'C105005001%' or ")
		  .append("t.owning_sub_id like 'C105007%' or t.owning_sub_id like 'C105063%' or ")
		  .append("t.owning_sub_id like 'C105086%' or t.owning_sub_id like 'C105008%' or ")
		  .append("t.owning_sub_id like 'C105087%' or t.owning_sub_id like 'C105092%' or ")
		  .append("t.owning_sub_id like 'C105093%' ) ")
		  .append(") tt left join comm_org_subjection s on s.org_subjection_id= tt.org_sub_id and s.bsflag = '0' ")
		  .append("left join comm_org_information i on i.org_id = s.org_id and i.bsflag = '0' ")
		  .append("group by tt.org_sub_id,i.org_abbreviation)) tt group by tt.label order by rate,tt.label desc");
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");	
		String orgName ="";
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
			int size = list.size();
			for (int i = size - 1; i > -1; i--) {
				Element set = root.addElement("set");
				Map map = list.get(i);
				orgName = map.get("label").toString();
				if("综合物化探处".equals(orgName)){
					orgName ="物化探";
				}else if("塔里木物探处".equals(orgName)){
					orgName ="塔里木";
				}else if("大庆物探一公司".equals(orgName)){
					orgName ="大庆一";
				}else if("大庆物探二公司".equals(orgName)){
					orgName ="大庆二";
				}else{
					orgName = orgName.substring(0,2);
				}
				set.addAttribute("label",orgName );
				set.addAttribute("value", map.get("rate").toString());
				set.addAttribute("displayValue", orgName+","+map.get("rate").toString()+"%");
				set.addAttribute("toolText", map.get("asset_value").toString()+"亿元");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 生产设备占比
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceProduceRate(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String display=reqDTO.getValue("display");//显示
		StringBuffer sb = new StringBuffer();
		sb.append("select tt.label,round(sum(ASSET_VALUE)/100000000,2) as ASSET_VALUE ,round(ratio_to_report(sum(ASSET_VALUE)) over(),4)*100 as rate  ")
		  .append("from (select nvl(dc.dev_ct_name,'其他') label,sum(ASSET_VALUE) as ASSET_VALUE  from ( ")
		  .append("select case when t.dev_type like 'S0808%' or t.dev_type like 'S0623%'  or t.dev_type like 'S0601%' then substr(t.dev_type,2,4) ")
		  .append("when t.dev_type like 'S08%' and t.dev_type not like 'S0808%' then substr(t.dev_type,2,2) ")		
		  .append(" end as dev_type,t.ASSET_VALUE ")
		  .append("from gms_device_account t where t.bsflag='0' and t.ifproduction='5110000186000000001' and t.account_stat='0110000013000000003') tt ")
		  .append("left join gms_device_codetype dc on tt.dev_type = dc.dev_ct_code  group by dev_ct_name union all ")
		  .append("select nvl(dc.dev_ct_name,'其他') label,sum(ASSET_VALUE) as ASSET_VALUE from ( ")
		  .append("select case when t.dev_type like 'S0808%' or t.dev_type like 'S0623%'  or t.dev_type like 'S0601%' then substr(t.dev_type,2,4) ")
		  .append("when t.dev_type like 'S08%' and t.dev_type not like 'S0808%' then substr(t.dev_type,2,2) ")
		  .append("when t.dev_type like 'S140501%'  then substr(t.dev_type,2,6) end as dev_type,t.ASSET_VALUE ")
		  .append("from gms_device_account_b t where t.bsflag='0' and t.ifproduction='5110000186000000001' and t.account_stat='0110000013000000003') tt ")
		  .append("left join gms_device_codetype dc on tt.dev_type = dc.dev_ct_code")
		  .append(" group by dev_ct_name ) tt group by tt.label order by  decode(tt.label,'其他',1,'2') ");
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		//大屏字体为微软雅黑，大小20
		if(null!=display && "bigScreen".equals(display)){
			root.addAttribute("baseFont", BigScreenUtil.BIG_SCREEN_FONT_FAMILY);
			root.addAttribute("baseFontSize", BigScreenUtil.BIG_SCREEN_FONT_SIZE);
		}else{
			root.addAttribute("baseFontSize", "12");
		}
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
			int size = list.size();
			for (int i = size - 1; i > -1; i--) {
				Element set = root.addElement("set");
				Map map = list.get(i);
				System.out.println(map.get("rate").toString());
				set.addAttribute("label", map.get("label").toString());
				set.addAttribute("value", map.get("rate").toString());
				set.addAttribute("displayValue", map.get("label").toString()+","+map.get("rate").toString()+"%");
				set.addAttribute("toolText", map.get("asset_value").toString()+"亿元");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 公司设备占比
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceCompanyRate(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String display=reqDTO.getValue("display");//显示
		StringBuffer sb = new StringBuffer();
		sb.append("select tt.label,round(sum(asset_value)/100000000,2) as asset_value,round(ratio_to_report(sum(ASSET_VALUE)) over(),4)*100 as rate ")
		  .append("from (select decode(t1.ifproduction,'1','生产设备','2','其他设备') as label, ")
		  .append("sum(asset_value) as asset_value from (select case when t.ifproduction='5110000186000000001' then '1' ")
		  .append("else  '2' end as ifproduction,t.asset_value   ")		
		  .append("from gms_device_account t where t.bsflag='0' and t.account_stat='0110000013000000003') t1 group by t1.ifproduction ")
		  .append("union all  select decode(t2.ifproduction,'1','生产设备','2','其他设备') as label, ")
		  .append("sum(asset_value) as asset_value from (select case when t.ifproduction='5110000186000000001' then '1'  ")
		  .append("else  '2' end as ifproduction,t.asset_value ")
		  .append(" from gms_device_account_b t where t.bsflag='0' and t.account_stat='0110000013000000003' )t2 group by t2.ifproduction ) ")
		  .append(" tt group by tt.label order by rate,tt.label desc");
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		//大屏字体为微软雅黑，大小20
		if(null!=display && "bigScreen".equals(display)){
			root.addAttribute("baseFont", BigScreenUtil.BIG_SCREEN_FONT_FAMILY);
			root.addAttribute("baseFontSize", BigScreenUtil.BIG_SCREEN_FONT_SIZE);
		}else{
			root.addAttribute("baseFontSize", "12");
		}
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
			int size = list.size();
			for (int i = size - 1; i > -1; i--) {
				Element set = root.addElement("set");
				Map map = list.get(i);
				set.addAttribute("label", map.get("label").toString());
				set.addAttribute("value", map.get("rate").toString());
				set.addAttribute("displayValue", map.get("label").toString()+","+map.get("rate").toString()+"%");
				set.addAttribute("toolText", map.get("asset_value").toString()+"亿元");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		responseDTO.setValue("list", list);
		return responseDTO;
	}
	
	/**
	 * 设备资产配置情况
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceCapitalConfig(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String display=reqDTO.getValue("display");//显示
		StringBuffer sb = new StringBuffer();
		sb.append("select decode(tt.label,'1','野外采集','2','生产保障','3','科研单位','4','后勤保障','5','其他') as label , ")
		  .append("round(sum(tt.asset_value)/100000000,2) as asset_value,round(ratio_to_report(sum(ASSET_VALUE)) over(),4)*100 as rate  from ( select  ")
		  .append("case when t.owning_sub_id like 'C105002%' or t.owning_sub_id like 'C105001005%' or ")
		  .append("t.owning_sub_id like 'C105001002%' or t.owning_sub_id like 'C105001003%' or ")		
		  .append("t.owning_sub_id like 'C105001004%' or t.owning_sub_id like 'C105005004%' or ")
		  .append("t.owning_sub_id like 'C105005000%' or t.owning_sub_id like 'C105005001%' or ")
		  .append("t.owning_sub_id like 'C105007%' or t.owning_sub_id like 'C105063%' or ")
		  .append("t.owning_sub_id like 'C105086%' or t.owning_sub_id like 'C105008%' then '1' ")
		  .append("when t.owning_sub_id like 'C105006%'  then '2' ")
		  .append("when  t.owning_sub_id like 'C105003%' then '3' ")
		  .append("when  t.owning_sub_id like 'C105017%' then '4' else '5' end as label,t.asset_value ")
		  .append("from gms_device_account t where t.bsflag='0' and t.account_stat='0110000013000000003' union all  ")
		  .append("select case when t.owning_sub_id like 'C105002%' or t.owning_sub_id like 'C105001005%' or ")
		  .append("t.owning_sub_id like 'C105001002%' or t.owning_sub_id like 'C105001003%' or ")
		  .append("t.owning_sub_id like 'C105001004%' or t.owning_sub_id like 'C105005004%' or ")
		  .append("t.owning_sub_id like 'C105005000%' or t.owning_sub_id like 'C105005001%' or ")
		  .append("t.owning_sub_id like 'C105007%' or t.owning_sub_id like 'C105063%' or ")
		  .append("t.owning_sub_id like 'C105086%' or t.owning_sub_id like 'C105008%' then '1' ")
		  .append("when t.owning_sub_id like 'C105006%'  then '2' ")
		  .append("when t.owning_sub_id like 'C105003%' then '3' ")
		  .append("when t.owning_sub_id like 'C105017%' then '4' else '5'  end as label,t.asset_value ")
		  .append("from gms_device_account_b t where t.bsflag='0' and t.account_stat='0110000013000000003') tt group by tt.label order by rate,tt.label desc");
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		//大屏字体为微软雅黑，大小20
		if(null!=display && "bigScreen".equals(display)){
			root.addAttribute("baseFont", BigScreenUtil.BIG_SCREEN_FONT_FAMILY);
			root.addAttribute("baseFontSize", BigScreenUtil.BIG_SCREEN_FONT_SIZE);
		}else{
			root.addAttribute("baseFontSize", "12");
		}
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
			int size = list.size();
			int j = 1;
			for (int i = size - 1; i > -1; i--) {
				Element set = root.addElement("set");
				Map map = list.get(i);
				System.out.println(map.get("asset_value").toString());
				set.addAttribute("label", map.get("label").toString());
				set.addAttribute("value", map.get("rate").toString());
				set.addAttribute("displayValue", map.get("label").toString()+","+map.get("rate").toString()+"%");
				set.addAttribute("toolText", map.get("asset_value").toString()+"亿元");
				j++;
			}
		}
		responseDTO.setValue("Str", document.asXML());
		responseDTO.setValue("list", list);
		return responseDTO;
	} 
}
