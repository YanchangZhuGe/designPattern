package com.bgp.dms.use;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * @ClassName: MainEquiBasiStatSrv
 * @Description:��Ҫ�豸�������ͳ�Ʒ�������
 * @author dushuai
 * @date 2015-5-11
 */
public class MainEquiBasiStatSrv extends BaseService {

	public MainEquiBasiStatSrv() {
		log = LogFactory.getLogger(MainEquiBasiStatSrv.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	IBaseDao baseDao = BeanFactory.getBaseDao();

	/**
	 * ��ȡ��Ҫ�豸�������ͳ�Ʒ�������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTableChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// �Ƿ�����
		String account_stat = isrvmsg.getValue("account_stat");
		if(StringUtils.isBlank(account_stat)){
			account_stat="";
		}
		// ��̽��
		String wutanorg = isrvmsg.getValue("wutanorg");
		if(StringUtils.isBlank(wutanorg)){
			wutanorg="";
		}
		// �Ƿ������豸
		String ifproduction = isrvmsg.getValue("ifproduction");
		if(StringUtils.isBlank(ifproduction)){
			ifproduction="";
		}
		// ����(Ĭ��Ϊ��һ��)
		String level = isrvmsg.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// ������
		String parentCode = isrvmsg.getValue("parentCode");
		if(StringUtils.isBlank(parentCode)){
			parentCode="";
		}
		StringBuilder sql = new StringBuilder(
				"select t.*,case when d.device_type is null then d.device_name else d.device_name||'('||d.device_type||')' end as device_name,"
						+ " case when d.dev_tree_id like 'D001%' then '��'  when d.dev_tree_id like 'D002%' or d.dev_tree_id like 'D003%'  then '̨'"
						+ " when d.dev_tree_id like 'D005%' then '��'  when d.dev_tree_id like 'D004%' or d.dev_tree_id like 'D006%'  then '��' end as unit"
						+ " from (select substr(dt.dev_tree_id, 1, "+subStrLength+") as device_code,"
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
						+ " where dh.bsflag = '0'  and dh.country in ('����','����')" 
						+ " and dh.his_date=(select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");
						
		// ��̽��
		if(StringUtils.isNotBlank(wutanorg) && (!"C105".equals(wutanorg))){
			sql.append(" and dh.org_subjection_id like '"+wutanorg+"%'");
		}
		// ��̽��
		if(StringUtils.isNotBlank(ifproduction)){
			sql.append(" and dh.ifproduction='"+ifproduction+"'");
		}
		// �Ƿ�����
		if(StringUtils.isNotBlank(account_stat)){
			sql.append(" and dh.account_stat='"+account_stat+"'");
		}
		 
		sql.append(" ) tdh on tdh.device_type = dt.device_code where dt.bsflag='0'");
		// tree����
		if(StringUtils.isNotBlank(parentCode)){
			sql.append(" and dt.dev_tree_id like '" + parentCode + "%' and dt.dev_tree_id <> '" + parentCode + "'");
		}
		sql.append(" group by substr(dt.dev_tree_id, 1,"+subStrLength+")) t " +
				"left join dms_device_tree d on t.device_code = d.dev_tree_id order by d.code_order");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	public ISrvMsg firstLevel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String device_name = reqDTO.getValue("device_name");
		String parent_id = reqDTO.getValue("parent_id");
		String num_type = reqDTO.getValue("num_type");
		String if_country = reqDTO.getValue("if_country");
		String sql = getDrillSqlForTwo("COM", parent_id, if_country, null);
		StringBuffer sb = new StringBuffer();
		List list = jdbcDao.queryRecords(sql);
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='"
				+ device_name + "�������ͳ��"
				+ "' XAxisName='' showValues='1' unescapeLinks='0' palette='2' animation='1' formatNumberScale='0' numberPrefix='' showValues='0' numDivLines='4' legendPosition='BOTTOM'>");
		String categories = "";
		String zs = "";
		String zy = "";
		String xz_little = "";
		String xz = "";
		String qt = "";
		String dbf = "";
		String type = "";
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				Map map = (Map) list.get(i);
				if (map != null) {
					String id = (String) map.get("id");
					String name = (String) map.get("name");
					categories = categories + "<category label='"
							+ name
							+ "' />";

					if (num_type == null || num_type.trim().equals("")) {
						if (parent_id != null
								&& (parent_id.trim().equals("1") || parent_id
										.trim().equals("2"))) {
							zs = zs + "<set value='" + (String) map.get("zs")
									+ "'/>";
							zy = zy + "<set value='" + (String) map.get("zy")
									+ "'/>";
							xz_little = xz_little + "<set value='"
									+ (String) map.get("xz_little") + "'/>";
							xz = xz + "<set value='" + (String) map.get("xz")
									+ "'/>";
							qt = qt + "<set value='" + (String) map.get("qt")
									+ "'/>";
							dbf = dbf + "<set value='"
									+ (String) map.get("dbf") + "'/>";
						} else {
							zs = zs + "<set value='" + (String) map.get("zs")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','zs')\"/>";
							zy = zy + "<set value='" + (String) map.get("zy")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','zy')\"/>";
							xz_little = xz_little + "<set value='"
									+ (String) map.get("xz_little")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','xz_little')\"/>";
							xz = xz + "<set value='" + (String) map.get("xz")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','xz')\"/>";
							qt = qt + "<set value='" + (String) map.get("qt")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','qt')\"/>";
							dbf = dbf + "<set value='"
									+ (String) map.get("dbf")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','dbf')\"/>";
						}

					} else {
						if (parent_id != null
								&& (parent_id.trim().equals("1") || parent_id
										.trim().equals("2"))) {
							type = type + "<set value='"
									+ (String) map.get(num_type) + "'/>";
						} else {
							type = type + "<set value='"
									+ (String) map.get(num_type)
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','" + num_type + "')\"/>";
						}

					}
				}
			}
		}
		String dataset = "";
		if (num_type == null || num_type.trim().equals("")) {
			dataset = "<dataset seriesName='"
					+ "����" + "'>" + zs
					+ "</dataset><dataset seriesName='"
					+ "����" + "'>" + zy
					+ "</dataset><dataset seriesName='"
					+ "����(С��1����)" + "'>"
					+ xz_little + "</dataset><dataset seriesName='"
					+ "����(����1����)" + "'>"
					+ xz + "</dataset><dataset seriesName='"
					+ "����\\����" + "'>" + qt
					+ "</dataset><dataset seriesName='"
					+ "������" + "'>" + dbf
					+ "</dataset>";
		} else {
			if (num_type.equals("zs")) {
				dataset = "<dataset seriesName='"
						+ "����" + "'>"
						+ type + "</dataset>";
			} else if (num_type.equals("zy")) {
				dataset = "<dataset seriesName='"
						+ "����" + "'>"
						+ type + "</dataset>";
			} else if (num_type.equals("xz_little")) {
				dataset = "<dataset seriesName='"
						+ "����(С��1����)"
						+ "'>" + type + "</dataset>";
			} else if (num_type.equals("xz")) {
				dataset = "<dataset seriesName='"
						+ "����(����1����)"
						+ "'>" + type + "</dataset>";
			} else if (num_type.equals("qt")) {
				dataset = "<dataset seriesName='"
						+ "����\\����" + "'>"
						+ type + "</dataset>";
			} else {
				dataset = "<dataset seriesName='"
						+ "������" + "'>"
						+ type + "</dataset>";
			}
		}
		str.append("<categories>").append(categories).append("</categories>")
				.append(dataset);
		str.append(
				" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' /><style type='font' name='SubCaptionFont' bold='0' /></definition>")
				.append(" <application><apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		msg.setValue("Str", Str);
		System.out.println(Str);
		return msg;
	}

	/**
	 * ˵������ù�˾������̽����������ȡ�Ĳ�ѯsql
	 * 
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public String getDrillSqlForTwo(String showid, String parentid,
			String ifcountry, String orgsubid) {
		List<Map> conditionList = getDrillConditionForTwo(showid, parentid);
		StringBuffer sb = new StringBuffer();
		if ("COM".equals(showid)) {
			if ("1".equals(parentid)) {
				sb.append(
						"select base.id,base.name,base.code,nvl(tempzs.zs,0) as zs,")
						.append("nvl(tempzs.zy,0) as zy,0 as xz_little,nvl(tempzs.xz,0) as xz,nvl(tempzs.qt,0) as qt,nvl(tempzs.dbf,0) as dbf ")
						.append("from (select id,code,name,seq from gms_device_showparam where showid='COM' and parentid='1') base ")
						.append("left join (");
				int index = 0;
				for (Map paramMap : conditionList) {
					if (index > 0) {
						sb.append(" union ");
					}
					sb.append(
							"(select '"
									+ paramMap.get("id")
									+ "' as id,sum(ci.dev_slot_num * ca.total_num) as zs,sum(ci.dev_slot_num * ca.use_num) as zy,")
							.append("sum(ci.dev_slot_num * ca.unuse_num) as xz,sum(ci.dev_slot_num * cat.repairing_num) as qt,")
							.append("sum(ci.dev_slot_num * cat.touseless_num) as dbf ")
							.append("from gms_device_coll_account ca ")
							.append("left join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id ")
							.append("left join gms_device_collectinfo ci on ca.device_id = ci.device_id ")
							.append("where ").append(" ca.")
							.append(paramMap.get("condition")).append(") ");
					index++;
				}
				sb.append(") tempzs on base.id=tempzs.id order by base.seq");
			} else if ("7".equals(parentid)) {
				sb.append(
						"select base.id,base.name,base.code,nvl(tempzs.zs,0) as zs,")
						.append("nvl(tempzs.zy,0) as zy,0 as xz_little,nvl(tempzs.xz,0) as xz,nvl(tempzs.qt,0) as qt,nvl(tempzs.dbf,0) as dbf ")
						.append("from (select id,code,name,seq from gms_device_showparam where showid='COM' and parentid='7') base ")
						.append("left join (");
				int index = 0;
				for (Map paramMap : conditionList) {
					if (index > 0) {
						sb.append(" union ");
					}
					sb.append(
							"(select '"
									+ paramMap.get("id")
									+ "' as id,sum(ca.total_num) as zs,sum(ca.use_num) as zy,")
							.append("sum(ca.unuse_num) as xz,sum(cat.repairing_num) as qt,")
							.append("sum(cat.touseless_num) as dbf ")
							.append("from gms_device_coll_account ca ")
							.append("left join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id where 1=1 ");
					if (ifcountry != null && "1".equals(ifcountry)) {// ����
						sb.append("and (ca.ifcountry != '����' or ca.ifcountry is null) ");
					} else if (ifcountry != null && "2".equals(ifcountry)) {// ����
						sb.append("and ca.ifcountry = '����' ");
					}
					sb.append("and ca.bsflag = '0' and( ca.")
							.append(paramMap.get("condition")).append(") ");
					index++;
				}
				sb.append(") tempzs on base.id=tempzs.id order by base.seq");
			} else {
				// ����������2����ȡ
				sb.append(
						"select base.id,base.name,base.code,nvl(tempdata.zs,0) as zs,")
						.append("nvl(tempdata.zy,0) as zy,nvl(tempdata.xz_little,0) as xz_little,nvl(tempdata.xz,0) as xz,nvl(tempdata.wx,0) as qt,nvl(tempdata.dbf,0) as dbf ")
						.append("from (select id,code,name,seq from gms_device_showparam where showid='COM' and parentid='"
								+ parentid + "') base ").append("left join (");
				int index = 0;
				for (Map paramMap : conditionList) {
					if (index > 0) {
						sb.append(" union ");
					}
					sb.append("(select tempzs.id,tempzs.zs,tempzy.zy,tempxzlittle.xz_little,tempxz.xz,tempwx.wx,tempdbf.dbf from ");
					sb.append(
							"(select '" + paramMap.get("id")
									+ "' as id,count(1) as zs ")
							.append("from gms_device_account acc ")
							.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and ")
							.append(paramMap.get("condition"));
					if (ifcountry != null && "1".equals(ifcountry)) {// ����
						sb.append(" and (acc.ifcountry != '����' or acc.ifcountry is null) ");
					} else if (ifcountry != null && "2".equals(ifcountry)) {// ����
						sb.append(" and acc.ifcountry = '����' ");
					}
					sb.append(" ) tempzs left join  ");
					sb.append(
							"(select '" + paramMap.get("id")
									+ "' as id,count(1) as zy ")
							.append("from gms_device_account acc ")
							.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000001' and ")
							.append(paramMap.get("condition"));
					if (ifcountry != null && "1".equals(ifcountry)) {// ����
						sb.append(" and (acc.ifcountry != '����' or acc.ifcountry is null) ");
					} else if (ifcountry != null && "2".equals(ifcountry)) {// ����
						sb.append(" and acc.ifcountry = '����' ");
					}
					sb.append(" ) tempzy on tempzs.id=tempzy.id left join  ");
					sb.append(
							"(select '" + paramMap.get("id")
									+ "' as id,count(1) as xz_little ")
							.append("from gms_device_account acc ")
							.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000002' and (acc.check_time is not null and acc.check_time>=trunc(add_months(sysdate,-1),'dd')) and ")
							.append(paramMap.get("condition"));
					if (ifcountry != null && "1".equals(ifcountry)) {// ����
						sb.append(" and (acc.ifcountry != '����' or acc.ifcountry is null) ");
					} else if (ifcountry != null && "2".equals(ifcountry)) {// ����
						sb.append(" and acc.ifcountry = '����' ");
					}
					sb.append(" ) tempxzlittle on tempzs.id=tempxzlittle.id left join  ");
					sb.append(
							"(select '" + paramMap.get("id")
									+ "' as id,count(1) as xz ")
							.append("from gms_device_account acc ")
							.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000002' and (acc.check_time is null or acc.check_time<trunc(add_months(sysdate,-1),'dd')) and ")
							.append(paramMap.get("condition"));
					if (ifcountry != null && "1".equals(ifcountry)) {// ����
						sb.append(" and (acc.ifcountry != '����' or acc.ifcountry is null) ");
					} else if (ifcountry != null && "2".equals(ifcountry)) {// ����
						sb.append(" and acc.ifcountry = '����' ");
					}
					sb.append(" ) tempxz on tempzs.id=tempxz.id left join  ");
					sb.append(
							"(select '" + paramMap.get("id")
									+ "' as id,count(1) as wx ")
							.append("from gms_device_account acc ")
							.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000006' ")
							.append("and (acc.tech_stat = '0110000006000000006' or acc.tech_stat = '0110000006000000007') ")
							.append("and ").append(paramMap.get("condition"));
					if (ifcountry != null && "1".equals(ifcountry)) {// ����
						sb.append(" and (acc.ifcountry != '����' or acc.ifcountry is null) ");
					} else if (ifcountry != null && "2".equals(ifcountry)) {// ����
						sb.append(" and acc.ifcountry = '����' ");
					}
					sb.append(" ) tempwx on tempzs.id=tempwx.id left join  ");
					sb.append(
							"(select '" + paramMap.get("id")
									+ "' as id,count(1) as dbf ")
							.append("from gms_device_account acc ")
							.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000006' ")
							.append("and acc.tech_stat = '0110000006000000005' ")
							.append("and ").append(paramMap.get("condition"));
					if (ifcountry != null && "1".equals(ifcountry)) {// ����
						sb.append(" and (acc.ifcountry != '����' or acc.ifcountry is null) ");
					} else if (ifcountry != null && "2".equals(ifcountry)) {// ����
						sb.append(" and acc.ifcountry = '����' ");
					}
					sb.append(") tempdbf on tempzs.id=tempdbf.id ) ");
					index++;
				}
				sb.append(") tempdata on base.id=tempdata.id order by base.seq");
			}
		} else if ("WUTAN".equals(showid)) {
			// ����������2����ȡ
			sb.append(
					"select base.id,base.name,base.code,nvl(tempdata.zs,0) as zs,")
					.append("nvl(tempdata.zy,0) as zy,nvl(tempdata.xz_little,0) as xz_little,nvl(tempdata.xz,0) as xz,nvl(tempdata.qt,0) as qt,")
					.append("nvl(tempdata.dx,0) as dx,nvl(tempdata.zx,0) as zx,nvl(tempdata.dbf,0) as dbf ")
					.append("from (select id,code,name,seq from gms_device_showparam where showid='WUTAN' and parentid='"
							+ parentid + "') base ").append("left join (");
			int index = 0;
			for (Map paramMap : conditionList) {
				if (index > 0) {
					sb.append(" union ");
				}
				sb.append("(select tempzs.id,tempzs.zs,tempzy.zy,tempxzlittle.xz_little,tempxz.xz,tempqt.qt,tempdx.dx,tempzx.zx,tempdbf.dbf from ");
				sb.append(
						"(select '" + paramMap.get("id")
								+ "' as id,count(1) as zs ")
						.append("from gms_device_account acc ")
						.append("where 1=1 and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id like '" + orgsubid
								+ "%') tempzs left join  ");
				sb.append(
						"(select '" + paramMap.get("id")
								+ "' as id,count(1) as zy ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000001' and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id like '"
								+ orgsubid
								+ "%') tempzy on tempzs.id=tempzy.id left join  ");
				sb.append(
						"(select '" + paramMap.get("id")
								+ "' as id,count(1) as xz_little ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is not null and acc.check_time>=trunc(add_months(sysdate,-1),'dd')) and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id like '"
								+ orgsubid
								+ "%') tempxzlittle on tempzs.id=tempxzlittle.id left join  ");
				sb.append(
						"(select '" + paramMap.get("id")
								+ "' as id,count(1) as xz ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is null or acc.check_time<trunc(add_months(sysdate,-1),'dd')) and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id like '"
								+ orgsubid
								+ "%') tempxz on tempzs.id=tempxz.id left join  ");
				sb.append(
						"(select '" + paramMap.get("id")
								+ "' as id,count(1) as qt ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000006' ")
						.append("and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id like '"
								+ orgsubid
								+ "%') tempqt on tempzs.id=tempqt.id left join  ");
				sb.append(
						"(select '" + paramMap.get("id")
								+ "' as id,count(1) as dx ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000006' ")
						.append("and acc.tech_stat = '0110000006000000006' ")
						.append("and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id like '"
								+ orgsubid
								+ "%') tempdx on tempzs.id=tempdx.id left join  ");
				sb.append(
						"(select '" + paramMap.get("id")
								+ "' as id,count(1) as zx ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000006' ")
						.append("and acc.tech_stat = '0110000006000000007' ")
						.append("and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id like '"
								+ orgsubid
								+ "%') tempzx on tempzs.id=tempzx.id left join  ");
				sb.append(
						"(select '" + paramMap.get("id")
								+ "' as id,count(1) as dbf ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000006' ")
						.append("and acc.tech_stat = '0110000006000000005' ")
						.append("and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id like '" + orgsubid
								+ "%') tempdbf on tempzs.id=tempdbf.id ) ");
				index++;
			}
			sb.append(") tempdata on base.id=tempdata.id order by base.seq");
		}
		return sb.toString();
	}

	/**
	 * ����
	 * 
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public List<Map> getDrillConditionForTwo(String showid, String parentid) {
		List<Map> paramList = null;
		if ("COM".equals(showid)) {
			if (parentid == null) {
				// ��˾��һ����ȡ
				String sqlinfo = "select id,name,code,showtype,seq from gms_device_showparam "
						+ "where showid='COM' and parentid is null order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for (Map paramMap : paramList) {
					if ("DZYQ".equals(paramMap.get("code"))) {
						paramMap.put("condition", "");
					} else {
						// 1������like������������
						paramMap.put("condition",
								"dev_type like '" + paramMap.get("code") + "' ");
					}
				}
			} else if ("1".equals(parentid)) {
				// ��˾���ĵ�������������������
				String sqlinfo = "select id,name,code,showtype,seq from gms_device_showparam "
						+ "where showid='COM' and parentid='1' order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for (Map paramMap : paramList) {
					paramMap.put(
							"condition",
							"device_id in (select device_id from gms_device_collectinfo where dev_model like '%"
									+ paramMap.get("name")
									+ "%'and dev_code not like '04%')");
				}
			} else if ("7".equals(parentid)) {
				// ��˾���ļ첨����������
				String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "
						+ "where showid='COM' and parentid='"
						+ parentid
						+ "' order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for (Map paramMap : paramList) {
					String code = paramMap.get("code").toString();
					String showtype = paramMap.get("showtype").toString();
					String othertype = paramMap.get("othertype").toString();
					String otherinfo = paramMap.get("otherinfo").toString();
					String condition = "device_id " + showtype + " '" + code
							+ "' ";
					if (othertype != null) {
						if ("IN".equals(othertype)) {
							condition += "or device_id " + othertype + " ('"
									+ otherinfo.replaceAll(",", "','") + "') ";
						}
					}
					condition += ") ";
					paramMap.put("condition", condition);
				}
			} else {
				String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "
						+ "where showid='COM' and parentid='"
						+ parentid
						+ "' order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for (Map paramMap : paramList) {
					String code = paramMap.get("code").toString();
					String showtype = paramMap.get("showtype").toString();
					String othertype = paramMap.get("othertype").toString();
					String otherinfo = paramMap.get("otherinfo").toString();
					String condition = " (dev_type " + showtype + " '" + code
							+ "' ";
					if (othertype != null) {
						if (othertype.startsWith("NOT")) {
							condition += "and dev_type " + othertype + " ('"
									+ otherinfo.replaceAll(",", "','") + "') ";
						} else if ("OR".equals(othertype)) {
							condition += "and dev_type = '" + otherinfo + "' ";
						} else if ("IN".equals(othertype)) {
							condition += "or dev_type " + othertype + " ('"
									+ otherinfo.replaceAll(",", "','") + "') ";
						} else if ("OR LIKE".equals(othertype)) {
							condition += "or dev_type like '" + otherinfo
									+ "' ";
						}
					}
					condition += ") ";
					paramMap.put("condition", condition);
				}
			}
		} else if ("WUTAN".equals(showid)) {
			// ��̽������ѯ�Ķ��ǵ�̨�豸
			if (parentid == null) {
				// ��̽��һ����ȡ
				String sqlinfo = "select id,name,code,showtype,seq from gms_device_showparam "
						+ "where showid='WUTAN' and parentid is null order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for (Map paramMap : paramList) {
					// 1������like������������
					paramMap.put("condition",
							"dev_type like '" + paramMap.get("code") + "' ");
				}
			} else {
				String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "
						+ "where showid='WUTAN' and parentid='"
						+ parentid
						+ "' order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for (Map paramMap : paramList) {
					String code = paramMap.get("code").toString();
					String showtype = paramMap.get("showtype").toString();
					String othertype = paramMap.get("othertype").toString();
					String otherinfo = paramMap.get("otherinfo").toString();
					String condition = " (dev_type " + showtype + " '" + code
							+ "' ";
					if (othertype != null) {
						if (othertype.startsWith("NOT")) {
							condition += "and dev_type " + othertype + " ('"
									+ otherinfo.replaceAll(",", "','") + "') ";
						} else if ("OR".equals(othertype)) {
							condition += "and dev_type = '" + otherinfo + "' ";
						} else if ("IN".equals(othertype)) {
							condition += "or dev_type " + othertype + " ('"
									+ otherinfo.replaceAll(",", "','") + "') ";
						} else if ("OR LIKE".equals(othertype)) {
							condition += "or dev_type like '" + otherinfo
									+ "' ";
						}
					}
					condition += ") ";
					paramMap.put("condition", condition);
				}
			}
		}
		return paramList;
	}

	/**
	 * ��Ҫ�豸�������ͳ�Ʊ� ��̽��
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg wtcLevel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String device_name = reqDTO.getValue("device_name");
		String parent_id = reqDTO.getValue("parent_id");
		String num_type = reqDTO.getValue("num_type");
		String sql = wtcSql("COM", parent_id, null);
		StringBuffer sb = new StringBuffer();
		List list = jdbcDao.queryRecords(sql);
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='"
				+ device_name + "�������ͳ��"
				+ "' XAxisName='' showValues='1' unescapeLinks='0' palette='2' animation='1' formatNumberScale='0' numberPrefix='' showValues='0' numDivLines='4' legendPosition='BOTTOM'>");
		// .append(" slantLabels='1' seriesNameInToolTip='1' sNumberSuffix='' yAxisName='"+"һ��Ʒ��","UTF-8")+"' numberSuffix='"+"%25","UTF-8")+"' useRoundEdges='1' ")
		// .append(" showValues='1' plotSpacePercent='"+"10%","UTF-8")+"' xAxisName='' bgColor='AEC0CA,FFFFFF' yAxisNamePadding ='0' adjustDiv='0' numDivLines='9'>");
		String categories = "";
		String zs = "";
		String zy = "";
		String xz_little = "";
		String xz = "";
		String qt = "";
		String dbf = "";
		String type = "";
		if (list == null || list.size() == 0) {
			sql = "select t.org_subjection_id id ,t.org_short_name name ,'0' zs,'0' zy,'0' xz_little,'0' xz,'0' qt,'0' dbf from bgp_comm_org_wtc t ";
			list = jdbcDao.queryRecords(sql);
		}
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				Map map = (Map) list.get(i);
				if (map != null) {
					String id = (String) map.get("id");
					String name = (String) map.get("name");
					categories = categories + "<category label='"
							+ name
							+ "' />";
					if (num_type == null || num_type.trim().equals("")) {
						String teamSql = teamSql("COM", parent_id, id);
						List teamList = jdbcDao.queryRecords(teamSql);
						teamList = null;
						if (teamList == null || teamList.size() == 0) {
							zs = zs + "<set value='" + (String) map.get("zs")
									+ "'/>";
							zy = zy + "<set value='" + (String) map.get("zy")
									+ "'/>";
							xz_little = xz_little + "<set value='"
									+ (String) map.get("xz_little") + "'/>";
							xz = xz + "<set value='" + (String) map.get("xz")
									+ "'/>";
							qt = qt + "<set value='" + (String) map.get("qt")
									+ "'/>";
							dbf = dbf + "<set value='"
									+ (String) map.get("dbf") + "'/>";
						} else {
							zs = zs + "<set value='" + (String) map.get("zs")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','zs','" + parent_id
									+ "')\"/>";
							zy = zy + "<set value='" + (String) map.get("zy")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','zy','" + parent_id
									+ "')\"/>";
							xz_little = xz_little + "<set value='"
									+ (String) map.get("xz_little")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','xz_little','"
									+ parent_id + "')\"/>";
							xz = xz + "<set value='" + (String) map.get("xz")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','xz','" + parent_id
									+ "')\"/>";
							qt = qt + "<set value='" + (String) map.get("qt")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','qt','" + parent_id
									+ "')\"/>";
							dbf = dbf + "<set value='"
									+ (String) map.get("dbf")
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','dbf','" + parent_id
									+ "')\"/>";
						}

					} else {
						String teamSql = teamSql("COM", parent_id, id);
						List teamList = jdbcDao.queryRecords(teamSql);
						teamList = null;
						if (teamList == null || teamList.size() == 0) {
							type = type + "<set value='"
									+ (String) map.get(num_type) + "'/>";
						} else {
							type = type + "<set value='"
									+ (String) map.get(num_type)
									+ "' link=\"JavaScript:fusionChart('"
									+ name
									+ "','" + id + "','" + num_type + "','"
									+ parent_id + "')\"/>";
						}

					}
				}
			}
		}
		String dataset = "";
		if (num_type == null || num_type.trim().equals("")) {
			dataset = "<dataset seriesName='"
					+ "����" + "'>" + zs
					+ "</dataset><dataset seriesName='"
					+ "����" + "'>" + zy
					+ "</dataset><dataset seriesName='"
					+ "����(С��1����)" + "'>"
					+ xz_little + "</dataset><dataset seriesName='"
					+ "����(��ѧ1����)" + "'>"
					+ xz + "</dataset><dataset seriesName='"
					+ "����\\����" + "'>" + qt
					+ "</dataset><dataset seriesName='"
					+ "������" + "'>" + dbf
					+ "</dataset>";
		} else {
			if (num_type.equals("zs")) {
				dataset = "<dataset seriesName='"
						+ "����" + "'>"
						+ type + "</dataset>";
			} else if (num_type.equals("zy")) {
				dataset = "<dataset seriesName='"
						+ "����" + "'>"
						+ type + "</dataset>";
			} else if (num_type.equals("xz_little")) {
				dataset = "<dataset seriesName='"
						+ "����(С��1����)"
						+ "'>" + type + "</dataset>";
			} else if (num_type.equals("xz")) {
				dataset = "<dataset seriesName='"
						+ "����(����1����)"
						+ "'>" + type + "</dataset>";
			} else if (num_type.equals("qt")) {
				dataset = "<dataset seriesName='"
						+ "����\\����" + "'>"
						+ type + "</dataset>";
			} else {
				dataset = "<dataset seriesName='"
						+ "������" + "'>"
						+ type + "</dataset>";
			}
		}
		str.append("<categories>").append(categories).append("</categories>")
				.append(dataset);
		str.append(
				" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' /><style type='font' name='SubCaptionFont' bold='0' /></definition>")
				.append(" <application><apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		msg.setValue("Str", Str);
		System.out.println(Str);
		return msg;
	}

	public String wtcSql(String showid, String id, String orgsubid) {
		Map paramMap = getDrillConditionForThree(showid, id);
		StringBuffer sb = new StringBuffer();
		if ("COM".equals(showid)) {
			if ("1".equals(id) || "2".equals(id)) {
				// TODO 3����ȡͨ������Ľ���չ��������������flash��ֻ��1�� ������������⣬�õ���
			} else {
				// ���ն�����λ���з�����ʾ
				sb.append(
						"select tempzs.org_subjection_id id ,org.org_abbreviation as name,nvl(tempzs.zs,0) as zs,")
						.append("nvl(tempzy.zy,0) as zy,nvl(tempxzlittle.xz_little,0) as xz_little,nvl(tempxz.xz,0) as xz,nvl(tempwx.wx,0) as qt,nvl(tempdbf.dbf,0) as dbf from ");
				sb.append("(select wtc.org_subjection_id,count(1) as zs ")
						.append("from gms_device_account acc join bgp_comm_org_wtc wtc on acc.owning_sub_id like wtc.org_subjection_id ||'%' ")
						.append("where 1=1 and ")
						.append(paramMap.get("condition"))
						.append(" group by wtc.org_subjection_id ) tempzs left join  ");
				sb.append("(select wtc.org_subjection_id,count(1) as zy ")
						.append("from gms_device_account acc join bgp_comm_org_wtc wtc on acc.owning_sub_id like wtc.org_subjection_id ||'%' ")
						.append("where acc.using_stat = '0110000007000000001' and ")
						.append(paramMap.get("condition"))
						.append(" group by wtc.org_subjection_id ) tempzy on tempzs.org_subjection_id=tempzy.org_subjection_id left join  ");
				sb.append(
						"(select wtc.org_subjection_id,count(1) as xz_little ")
						.append("from gms_device_account acc join bgp_comm_org_wtc wtc on acc.owning_sub_id like wtc.org_subjection_id ||'%' ")
						.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is not null and acc.check_time>=trunc(add_months(sysdate,-1),'dd')) and ")
						.append(paramMap.get("condition"))
						.append(" group by wtc.org_subjection_id ) tempxzlittle on tempzs.org_subjection_id=tempxzlittle.org_subjection_id left join  ");
				sb.append("(select wtc.org_subjection_id,count(1) as xz ")
						.append("from gms_device_account acc join bgp_comm_org_wtc wtc on acc.owning_sub_id like wtc.org_subjection_id ||'%' ")
						.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is null or acc.check_time<trunc(add_months(sysdate,-1),'dd'))and ")
						.append(paramMap.get("condition"))
						.append(" group by wtc.org_subjection_id ) tempxz on tempzs.org_subjection_id=tempxz.org_subjection_id left join  ");
				sb.append("(select wtc.org_subjection_id,count(1) as wx ")
						.append("from gms_device_account acc join bgp_comm_org_wtc wtc on acc.owning_sub_id like wtc.org_subjection_id ||'%' ")
						.append("where acc.using_stat = '0110000007000000006' ")
						.append("and (acc.tech_stat = '0110000006000000006' or acc.tech_stat = '0110000006000000007') ")
						.append("and ")
						.append(paramMap.get("condition"))
						.append(" group by wtc.org_subjection_id ) tempwx on tempzs.org_subjection_id=tempwx.org_subjection_id left join  ");
				sb.append("(select wtc.org_subjection_id,count(1) as dbf ")
						.append("from gms_device_account acc join bgp_comm_org_wtc wtc on acc.owning_sub_id like wtc.org_subjection_id ||'%' ")
						.append("where acc.using_stat = '0110000007000000006' ")
						.append("and acc.tech_stat = '0110000006000000005' ")
						.append("and ")
						.append(paramMap.get("condition"))
						.append(" group by wtc.org_subjection_id ) tempdbf on tempzs.org_subjection_id=tempdbf.org_subjection_id ");
				sb.append("left join comm_org_subjection orgsub on tempzs.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' ");
				sb.append("left join comm_org_information org on orgsub.org_id=org.org_id ");
			}
		} else if ("WUTAN".equals(showid)) {
			// ��̽������ȡ�������õ�����չ������Ŀ��
			sb.append("select tempzy.project_info_no,pro.project_name,nvl(tempzy.zy,0) as zy from ");
			sb.append("(select acc.project_info_no,count(1) as zy ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000001' and ")
					.append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"
							+ orgsubid
							+ "%' and acc.project_info_no is not null group by project_info_no ) tempzy ");
			sb.append("left join gp_task_project pro on pro.project_info_no=tempzy.project_info_no ");
		}
		return sb.toString();
	}

	/**
	 * ����
	 * 
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public Map getDrillConditionForThree(String showid, String id) {
		Map paramMap = null;
		if ("COM".equals(showid)) {
			if (id == null) {
				// TODO 1�������� ������������⣬�õ���
			} else if ("1".equals(id)) {
				// ��������û��������ȡ
			} else {
				String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "
						+ "where showid='COM' and id='" + id + "' ";
				paramMap = jdbcDao.queryRecordBySQL(sqlinfo);

				String code = paramMap.get("code").toString();
				String showtype = paramMap.get("showtype").toString();
				String othertype = paramMap.get("othertype").toString();
				String otherinfo = paramMap.get("otherinfo").toString();
				String condition = " (dev_type " + showtype + " '" + code
						+ "' ";
				if (othertype != null) {
					if (othertype.startsWith("NOT")) {
						condition += "and dev_type " + othertype + " ('"
								+ otherinfo.replaceAll(",", "','") + "') ";
					} else if ("OR".equals(othertype)) {
						condition += "and dev_type = '" + otherinfo + "' ";
					} else if ("IN".equals(othertype)) {
						condition += "or dev_type " + othertype + " ('"
								+ otherinfo.replaceAll(",", "','") + "') ";
					} else if ("OR LIKE".equals(othertype)) {
						condition += "or dev_type like '" + otherinfo + "' ";
					}
					condition += ") ";
					paramMap.put("condition", condition);
				}
			}
		} else if ("WUTAN".equals(showid)) {
			// ��̽������ѯ�Ķ��ǵ�̨�豸
			String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "
					+ "where showid='WUTAN' and id='" + id + "' ";
			paramMap = jdbcDao.queryRecordBySQL(sqlinfo);

			String code = paramMap.get("code").toString();
			String showtype = paramMap.get("showtype").toString();
			String othertype = paramMap.get("othertype").toString();
			String otherinfo = paramMap.get("otherinfo").toString();
			String condition = " (dev_type " + showtype + " '" + code + "' ";
			if (othertype != null) {
				if (othertype.startsWith("NOT")) {
					condition += "and dev_type " + othertype + " ('"
							+ otherinfo.replaceAll(",", "','") + "') ";
				} else if ("OR".equals(othertype)) {
					condition += "and dev_type = '" + otherinfo + "' ";
				} else if ("IN".equals(othertype)) {
					condition += "or dev_type " + othertype + " ('"
							+ otherinfo.replaceAll(",", "','") + "') ";
				} else if ("OR LIKE".equals(othertype)) {
					condition += "or dev_type like '" + otherinfo + "' ";
				}
				condition += ") ";
				paramMap.put("condition", condition);
			}
		}
		return paramMap;
	}

	public String teamSql(String showid, String id, String org_subjection_id) {
		Map paramMap = getDrillConditionForThree(showid, id);
		StringBuffer sb = new StringBuffer();
		if ("COM".equals(showid)) {
			if ("1".equals(id) || "2".equals(id)) {
				// TODO 3����ȡͨ������Ľ���չ��������������flash��ֻ��1�� ������������⣬�õ���
			} else {
				// ���ն�����λ���з�����ʾ
				sb.append(
						"select tempzs.owning_sub_id id ,org.org_abbreviation as name,nvl(tempzs.zs,0) as zs,")
						.append("nvl(tempzy.zy,0) as zy,nvl(tempxzlittle.xz_little,0) as xz_little,nvl(tempxz.xz,0) as xz,nvl(tempwx.wx,0) as qt,nvl(tempdbf.dbf,0) as dbf from ");
				sb.append("(select acc.owning_sub_id,count(1) as zs ")
						.append("from gms_device_account acc ")
						.append("where 1=1 and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id !='"
								+ org_subjection_id + "'")
						.append(" and acc.owning_sub_id like '"
								+ org_subjection_id
								+ "%' group by owning_sub_id ) tempzs left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as zy ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000001' and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id !='"
								+ org_subjection_id + "'")
						.append(" and acc.owning_sub_id like '"
								+ org_subjection_id
								+ "%' group by owning_sub_id ) tempzy on tempzs.owning_sub_id=tempzy.owning_sub_id left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as xz_little ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is not null and acc.check_time>=trunc(add_months(sysdate,-1),'dd')) and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id !='"
								+ org_subjection_id + "'")
						.append(" and acc.owning_sub_id like '"
								+ org_subjection_id
								+ "%' group by owning_sub_id ) tempxzlittle on tempzs.owning_sub_id=tempxzlittle.owning_sub_id left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as xz ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is null or acc.check_time<trunc(add_months(sysdate,-1),'dd'))and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id !='"
								+ org_subjection_id + "'")
						.append(" and acc.owning_sub_id like '"
								+ org_subjection_id
								+ "%' group by owning_sub_id ) tempxz on tempzs.owning_sub_id=tempxz.owning_sub_id left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as wx ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000006' ")
						.append("and (acc.tech_stat = '0110000006000000006' or acc.tech_stat = '0110000006000000007') ")
						.append("and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id !='"
								+ org_subjection_id + "'")
						.append(" and acc.owning_sub_id like '"
								+ org_subjection_id
								+ "%' group by owning_sub_id ) tempwx on tempzs.owning_sub_id=tempwx.owning_sub_id left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as dbf ")
						.append("from gms_device_account acc ")
						.append("where acc.using_stat = '0110000007000000006' ")
						.append("and acc.tech_stat = '0110000006000000005' ")
						.append("and ")
						.append(paramMap.get("condition"))
						.append(" and acc.owning_sub_id !='"
								+ org_subjection_id + "'")
						.append(" and acc.owning_sub_id like '"
								+ org_subjection_id
								+ "%' group by owning_sub_id ) tempdbf on tempzs.owning_sub_id=tempdbf.owning_sub_id ");
				sb.append("left join comm_org_subjection orgsub on tempzs.owning_sub_id=orgsub.org_subjection_id and orgsub.bsflag='0' ");
				sb.append("left join comm_org_information org on orgsub.org_id=org.org_id ");
			}
		} else if ("WUTAN".equals(showid)) {
			// ��̽������ȡ�������õ�����չ������Ŀ��
			sb.append("select tempzy.project_info_no,pro.project_name,nvl(tempzy.zy,0) as zy from ");
			sb.append("(select acc.project_info_no,count(1) as zy ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000001' and ")
					.append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"
							+ org_subjection_id
							+ "%' and acc.project_info_no is not null group by project_info_no ) tempzy ");
			sb.append("left join gp_task_project pro on pro.project_info_no=tempzy.project_info_no ");
		}
		return sb.toString();
	}

	/**
	 * ��Ҫ�豸�������ͳ�Ʊ� С��
	 */
	public ISrvMsg teamLevel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String device_name = reqDTO.getValue("device_name");
		String parent_id = reqDTO.getValue("parent_id");
		String org_subjection_id = reqDTO.getValue("org_subjection_id");
		String num_type = reqDTO.getValue("num_type");
		String sql = teamSql("COM", parent_id, org_subjection_id);
		StringBuffer sb = new StringBuffer();
		List list = jdbcDao.queryRecords(sql);
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='"
				+ device_name + "�������ͳ��"
				+ "' XAxisName='' showValues='1' unescapeLinks='0' palette='2' animation='1' formatNumberScale='0' numberPrefix='' showValues='0' numDivLines='4' legendPosition='BOTTOM'>");
		// .append(" slantLabels='1' seriesNameInToolTip='1' sNumberSuffix='' yAxisName='"+"һ��Ʒ��","UTF-8")+"' numberSuffix='"+"%25","UTF-8")+"' useRoundEdges='1' ")
		// .append(" showValues='1' plotSpacePercent='"+"10%","UTF-8")+"' xAxisName='' bgColor='AEC0CA,FFFFFF' yAxisNamePadding ='0' adjustDiv='0' numDivLines='9'>");
		String categories = "";
		String zs = "";
		String zy = "";
		String xz_little = "";
		String xz = "";
		String qt = "";
		String dbf = "";
		String type = "";
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				Map map = (Map) list.get(i);
				if (map != null) {
					String id = (String) map.get("id");
					String name = (String) map.get("name");
					categories = categories + "<category label='"
							+ name
							+ "' />";

					if (num_type == null || num_type.trim().equals("")) {
						zs = zs + "<set value='" + (String) map.get("zs")
								+ "'/>";
						zy = zy + "<set value='" + (String) map.get("zy")
								+ "'/>";
						xz_little = xz_little + "<set value='"
								+ (String) map.get("xz_little") + "'/>";
						xz = xz + "<set value='" + (String) map.get("xz")
								+ "'/>";
						qt = qt + "<set value='" + (String) map.get("qt")
								+ "'/>";
						dbf = dbf + "<set value='" + (String) map.get("dbf")
								+ "'/>";
					} else {
						type = type + "<set value='"
								+ (String) map.get(num_type) + "'/>";

					}
				}
			}
		}
		String dataset = "";
		if (num_type == null || num_type.trim().equals("")) {
			dataset = "<dataset seriesName='"
					+ "����" + "'>" + zs
					+ "</dataset><dataset seriesName='"
					+ "����" + "'>" + zy
					+ "</dataset><dataset seriesName='"
					+ "����(С��1����)" + "'>"
					+ xz_little + "</dataset><dataset seriesName='"
					+ "����(��ѧ1����)" + "'>"
					+ xz + "</dataset><dataset seriesName='"
					+ "����\\����" + "'>" + qt
					+ "</dataset><dataset seriesName='"
					+ "������" + "'>" + dbf
					+ "</dataset>";
		} else {
			if (num_type.equals("zs")) {
				dataset = "<dataset seriesName='"
						+ "����" + "'>"
						+ type + "</dataset>";
			} else if (num_type.equals("zy")) {
				dataset = "<dataset seriesName='"
						+ "����" + "'>"
						+ type + "</dataset>";
			} else if (num_type.equals("xz_little")) {
				dataset = "<dataset seriesName='"
						+ "����(С��1����)"
						+ "'>" + type + "</dataset>";
			} else if (num_type.equals("xz")) {
				dataset = "<dataset seriesName='"
						+ "����(����1����)"
						+ "'>" + type + "</dataset>";
			} else if (num_type.equals("qt")) {
				dataset = "<dataset seriesName='"
						+ "����\\����" + "'>"
						+ type + "</dataset>";
			} else {
				dataset = "<dataset seriesName='"
						+ "������" + "'>"
						+ type + "</dataset>";
			}
		}
		str.append("<categories>").append(categories).append("</categories>")
				.append(dataset);
		str.append(
				" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' /><style type='font' name='SubCaptionFont' bold='0' /></definition>")
				.append(" <application><apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		msg.setValue("Str", Str);
		System.out.println(Str);
		return msg;
	}
}
