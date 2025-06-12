package com.bgp.dms.device;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider;

public class DeviceBF extends BaseService{
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	
	public DeviceBF() {
		log = LogFactory.getLogger(DeviceBF.class);
		// TODO Auto-generated constructor stub
	}

	/**
	 * 设备原值比对
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevicebf(ISrvMsg isrvmsg) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String dev_type = isrvmsg.getValue("dev_type_id");//年度
		if(StringUtils.isBlank(dev_type)){
			dev_type="";
		}else{
			String[] dev_types = dev_type.split(",");
			String x = "";
			for(int i=0;i<dev_types.length;i++){	
				dev_types[i]="'"+dev_types[i]+"'";
			}
			dev_type = Arrays.toString(dev_types);
			dev_type=dev_type.replace("[","");
			dev_type=dev_type.replace("]","");
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("select t.dev_type dev_type,t.dev_name dev_name,tree.dev_tree_id dev_tree_id,count(dui.dev_type)/count(t.dev_type) count1,tree.device_type device_type, ");
		sb.append("nvl(avg(info.human_cost), 0) human_cost,nvl(avg(info.material_cost), 0) material_cost, ");
		sb.append("cast(nvl(avg(t.asset_value), 0) as decimal(10, 2)) value,cast(nvl(avg(m.mileage_total), 0) as decimal(10, 2)) total_money, ");
        sb.append("nvl(avg(info.human_cost + info.material_cost), 0) all_cost,cast(nvl(avg(m.mileage_total), 0) as decimal(10, 2)) m ");
        sb.append("from gms_device_account t ");
        sb.append("left join comm_coding_sort_detail d on t.account_stat = d.coding_code_id ");
        sb.append("left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id = t.dev_acc_id ");
        sb.append("left join GMS_MAT_TEAMMAT_OUT_DETAIL de on de.dev_acc_id = t.dev_acc_id ");
        sb.append("left join gms_device_account_dui dui on dui.fk_dev_acc_id = t.dev_acc_id and dui.bsflag = '0' and dui.is_leaving = '1' ");
        sb.append("left join gms_device_operation_info m on m.dev_acc_id = t.dev_acc_id ");
        sb.append("left join dms_scrape_detailed s on s.foreign_dev_id = t.dev_acc_id ");
        sb.append("inner join dms_device_tree tree on tree.device_code = t.dev_type ");
        sb.append("where d.coding_name = '报废' and t.ifproduction = '5110000186000000001' and s.scrape_date between ");
        sb.append("to_date('2009-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss') and sysdate ");
        if(dev_type!=""){
        	sb.append("and tree.dev_tree_id in ("+dev_type+")" );
        }
        sb.append("group by t.dev_type, t.dev_name,tree.dev_tree_id, tree.device_type");
	
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numberScaleUnit", "元");
		root.addAttribute("yAxisName", "(单位：元)");
		root.addAttribute("showValues", "0");
		// 构造数据
	    if (CollectionUtils.isNotEmpty(list)) {
	    	for(Map map:list){
				Element set = root.addElement("set");
				set.addAttribute("value", map.get("value").toString());
				set.addAttribute("label", map.get("dev_name").toString()+map.get("device_type").toString());
				set.addAttribute("displayValue",map.get("value").toString());
				set.addAttribute("toolText",map.get("value").toString()+"元");
	    	}
	    }
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 油料消耗比对
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceTotalMoney(ISrvMsg isrvmsg) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String dev_type = isrvmsg.getValue("dev_type_id");//年度
		if(StringUtils.isBlank(dev_type)){
			dev_type="";
		}else{
			String[] dev_types = dev_type.split(",");
			String x = "";
			for(int i=0;i<dev_types.length;i++){	
				dev_types[i]="'"+dev_types[i]+"'";
			}
			dev_type = Arrays.toString(dev_types);
			dev_type=dev_type.replace("[","");
			dev_type=dev_type.replace("]","");
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("select t.dev_type dev_type,t.dev_name dev_name,tree.dev_tree_id dev_tree_id,count(dui.dev_type)/count(t.dev_type) count1,tree.device_type device_type, ");
		sb.append("nvl(avg(info.human_cost), 0) human_cost,nvl(avg(info.material_cost), 0) material_cost, ");
		sb.append("cast(nvl(avg(t.asset_value), 0) as decimal(10, 2)) value,cast(nvl(avg(m.mileage_total), 0) as decimal(10, 2)) total_money, ");
        sb.append("nvl(avg(info.human_cost + info.material_cost), 0) all_cost,cast(nvl(avg(m.mileage_total), 0) as decimal(10, 2)) m ");
        sb.append("from gms_device_account t ");
        sb.append("left join comm_coding_sort_detail d on t.account_stat = d.coding_code_id ");
        sb.append("left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id = t.dev_acc_id ");
        sb.append("left join GMS_MAT_TEAMMAT_OUT_DETAIL de on de.dev_acc_id = t.dev_acc_id ");
        sb.append("left join gms_device_account_dui dui on dui.fk_dev_acc_id = t.dev_acc_id and dui.bsflag = '0' and dui.is_leaving = '1' ");
        sb.append("left join gms_device_operation_info m on m.dev_acc_id = t.dev_acc_id ");
        sb.append("left join dms_scrape_detailed s on s.foreign_dev_id = t.dev_acc_id ");
        sb.append("inner join dms_device_tree tree on tree.device_code = t.dev_type ");
        sb.append("where d.coding_name = '报废' and t.ifproduction = '5110000186000000001' and s.scrape_date between ");
        sb.append("to_date('2009-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss') and sysdate ");
        if(dev_type!=""){
        	sb.append("and tree.dev_tree_id in ("+dev_type+")" );
        }
        sb.append("group by t.dev_type, t.dev_name,tree.dev_tree_id, tree.device_type");
	
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numberScaleUnit", "公里");
		root.addAttribute("yAxisName", "(单位：公里)");
		root.addAttribute("showValues", "0");
		// 构造数据
	    if (CollectionUtils.isNotEmpty(list)) {
	    	for(Map map:list){
				Element set = root.addElement("set"); 
				set.addAttribute("value", map.get("total_money").toString());
				set.addAttribute("label", map.get("dev_name").toString()+map.get("device_type").toString());
				set.addAttribute("displayValue",map.get("total_money").toString());
				set.addAttribute("toolText", map.get("total_money").toString()+"升");
	    	}
	    }
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 行驶里程比对
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceMileage(ISrvMsg isrvmsg) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String dev_type = isrvmsg.getValue("dev_type_id");//年度
		if(StringUtils.isBlank(dev_type)){
			dev_type="";
		}else{
			String[] dev_types = dev_type.split(",");
			String x = "";
			for(int i=0;i<dev_types.length;i++){	
				dev_types[i]="'"+dev_types[i]+"'";
			}
			dev_type = Arrays.toString(dev_types);
			dev_type=dev_type.replace("[","");
			dev_type=dev_type.replace("]","");
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("select t.dev_type dev_type,t.dev_name dev_name,tree.dev_tree_id dev_tree_id,count(dui.dev_type)/count(t.dev_type) count1,tree.device_type device_type, ");
		sb.append("nvl(avg(info.human_cost), 0) human_cost,nvl(avg(info.material_cost), 0) material_cost, ");
		sb.append("cast(nvl(avg(t.asset_value), 0) as decimal(10, 2)) value,cast(nvl(avg(m.mileage_total), 0) as decimal(10, 2)) total_money, ");
        sb.append("nvl(avg(info.human_cost + info.material_cost), 0) all_cost,cast(nvl(avg(m.mileage_total), 0) as decimal(10, 2)) m ");
        sb.append("from gms_device_account t ");
        sb.append("left join comm_coding_sort_detail d on t.account_stat = d.coding_code_id ");
        sb.append("left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id = t.dev_acc_id ");
        sb.append("left join GMS_MAT_TEAMMAT_OUT_DETAIL de on de.dev_acc_id = t.dev_acc_id ");
        sb.append("left join gms_device_account_dui dui on dui.fk_dev_acc_id = t.dev_acc_id and dui.bsflag = '0' and dui.is_leaving = '1' ");
        sb.append("left join gms_device_operation_info m on m.dev_acc_id = t.dev_acc_id ");
        sb.append("left join dms_scrape_detailed s on s.foreign_dev_id = t.dev_acc_id ");
        sb.append("inner join dms_device_tree tree on tree.device_code = t.dev_type ");
        sb.append("where d.coding_name = '报废' and t.ifproduction = '5110000186000000001' and s.scrape_date between ");
        sb.append("to_date('2009-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss') and sysdate ");
        if(dev_type!=""){
        	sb.append("and tree.dev_tree_id in ("+dev_type+")" );
        }
        sb.append("group by t.dev_type, t.dev_name,tree.dev_tree_id, tree.device_type");
	
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numberScaleUnit", "升");
		root.addAttribute("yAxisName", "(单位：升)");
		root.addAttribute("showValues", "0");
		// 构造数据
	    if (CollectionUtils.isNotEmpty(list)) {
	    	for(Map map:list){
				Element set = root.addElement("set");
				set.addAttribute("value", map.get("m").toString());
				set.addAttribute("label", map.get("dev_name").toString()+map.get("device_type").toString());
				set.addAttribute("displayValue",map.get("m").toString());
				set.addAttribute("toolText", map.get("m").toString()+"升");
	    	}
	    }
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 参与项目比对
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceCount(ISrvMsg isrvmsg) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String dev_type = isrvmsg.getValue("dev_type_id");//年度
		if(StringUtils.isBlank(dev_type)){
			dev_type="";
		}else{
			String[] dev_types = dev_type.split(",");
			String x = "";
			for(int i=0;i<dev_types.length;i++){	
				dev_types[i]="'"+dev_types[i]+"'";
			}
			dev_type = Arrays.toString(dev_types);
			dev_type=dev_type.replace("[","");
			dev_type=dev_type.replace("]","");
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("select t.dev_type dev_type,t.dev_name dev_name,tree.dev_tree_id dev_tree_id,cast(nvl(count(dui.dev_type)/count(t.dev_type), 0) as decimal(10, 2))  count,tree.device_type device_type, ");
		sb.append("nvl(avg(info.human_cost), 0) human_cost,nvl(avg(info.material_cost), 0) material_cost, ");
		sb.append("cast(nvl(avg(t.asset_value), 0) as decimal(10, 2)) value,cast(nvl(avg(m.mileage_total), 0) as decimal(10, 2)) total_money, ");
        sb.append("nvl(avg(info.human_cost + info.material_cost), 0) all_cost,cast(nvl(avg(m.mileage_total), 0) as decimal(10, 2)) m ");
        sb.append("from gms_device_account t ");
        sb.append("left join comm_coding_sort_detail d on t.account_stat = d.coding_code_id ");
        sb.append("left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id = t.dev_acc_id ");
        sb.append("left join GMS_MAT_TEAMMAT_OUT_DETAIL de on de.dev_acc_id = t.dev_acc_id ");
        sb.append("left join gms_device_account_dui dui on dui.fk_dev_acc_id = t.dev_acc_id and dui.bsflag = '0' and dui.is_leaving = '1' ");
        sb.append("left join gms_device_operation_info m on m.dev_acc_id = t.dev_acc_id ");
        sb.append("left join dms_scrape_detailed s on s.foreign_dev_id = t.dev_acc_id ");
        sb.append("inner join dms_device_tree tree on tree.device_code = t.dev_type ");
        sb.append("where d.coding_name = '报废' and t.ifproduction = '5110000186000000001' and s.scrape_date between ");
        sb.append("to_date('2009-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss') and sysdate ");
        if(dev_type!=""){
        	sb.append("and tree.dev_tree_id in ("+dev_type+")" );
        }
        sb.append("group by t.dev_type, t.dev_name,tree.dev_tree_id, tree.device_type");
	
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numberScaleUnit", "个");
		root.addAttribute("yAxisName", "(单位：个)");
		root.addAttribute("showValues", "0");
		// 构造数据
	    if (CollectionUtils.isNotEmpty(list)) {
	    	for(Map map:list){
				Element set = root.addElement("set");
				set.addAttribute("value", map.get("count").toString());
				set.addAttribute("label", map.get("dev_name").toString()+map.get("device_type").toString());
				set.addAttribute("displayValue",map.get("count").toString());
				set.addAttribute("toolText", map.get("count").toString()+"个");
	    	}
	    }
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	private boolean inStr(String[] strs,String s){
		for (int i = 0; i < strs.length; i++) {
			if(s.equals(strs[i])){
				return true;
			}
		}
		return false;
	}

}
