package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//类名对应数据库表名
public class TempoZhzxDevTz {

	private static String TABLE = "tempo_zhzx_dev_tz";

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	// 插入数据
	public void insert() {

		this.delete();
		this.save();

		System.out.println("成功插入数据(" + TABLE + "): " + this.select() + "条");
	}

	// 删除表
	public void delete() {

		String sqString = "delete from " + TABLE + " ";
		jdbcDao.executeUpdate(sqString);
	}

	// 保存数据
	public void save() {

		String tableName = "  insert into " + TABLE + " ";
		String sqlString = tableName + "    select '完好' as x_num,\r\n" + 
				"           case\r\n" + 
				"             when d.device_type is null then\r\n" + 
				"              d.device_name\r\n" + 
				"             else\r\n" + 
				"              d.device_name || '(' || d.device_type || ')'\r\n" + 
				"           end as device_name,\r\n" + 
				"           case\r\n" + 
				"             when d.dev_tree_id like 'D001%' then\r\n" + 
				"              '道'\r\n" + 
				"             when d.dev_tree_id like 'D002%' or d.dev_tree_id like 'D003%' then\r\n" + 
				"              '台'\r\n" + 
				"             when d.dev_tree_id like 'D005%' then\r\n" + 
				"              '串'\r\n" + 
				"             when d.dev_tree_id like 'D004%' or d.dev_tree_id like 'D006%' then\r\n" + 
				"              '辆'\r\n" + 
				"             when d.dev_tree_id like 'D007%' then\r\n" + 
				"              '个'\r\n" + 
				"           end as unit,\r\n" + 
				"           t.*,\r\n" + 
				"           s.org_abbreviation\r\n" + 
				"      from (select orgsubidtoshortid(tdh.org_subjection_id) as org_code,\r\n" + 
				"                   substr(dt.dev_tree_id, 1, 4) as device_code,\r\n" + 
				"                   sum(nvl(case\r\n" + 
				"                             when tdh.country = '国内' then\r\n" + 
				"                              tdh.sum_num\r\n" + 
				"                           end,\r\n" + 
				"                           0)) + sum(nvl(case\r\n" + 
				"                                           when tdh.country = '国外' then\r\n" + 
				"                                            tdh.sum_num\r\n" + 
				"                                         end,\r\n" + 
				"                                         0)) as 总量,\r\n" + 
				"                   sum(nvl(case\r\n" + 
				"                             when tdh.country = '国内' and\r\n" + 
				"                                  tdh.account_stat != '0110000013000000001' then\r\n" + 
				"                              tdh.use_num\r\n" + 
				"                           end,\r\n" + 
				"                           0)) + sum(nvl(case\r\n" + 
				"                                           when tdh.country = '国外' and\r\n" + 
				"                                                tdh.account_stat != '0110000013000000001' then\r\n" + 
				"                                            tdh.use_num\r\n" + 
				"                                         end,\r\n" + 
				"                                         0)) as 在用_非报废,\r\n" + 
				"                   sum(nvl(case\r\n" + 
				"                             when tdh.country = '国内' and\r\n" + 
				"                                  tdh.account_stat = '0110000013000000001' then\r\n" + 
				"                              tdh.use_num\r\n" + 
				"                           end,\r\n" + 
				"                           0)) + sum(nvl(case\r\n" + 
				"                                           when tdh.country = '国外' and\r\n" + 
				"                                                tdh.account_stat = '0110000013000000001' then\r\n" + 
				"                                            tdh.use_num\r\n" + 
				"                                         end,\r\n" + 
				"                                         0)) as 在用_报废,\r\n" + 
				"                   sum(nvl(case\r\n" + 
				"                             when tdh.country = '国内' then\r\n" + 
				"                              tdh.idle_num\r\n" + 
				"                           end,\r\n" + 
				"                           0)) + sum(nvl(case\r\n" + 
				"                                           when tdh.country = '国外' then\r\n" + 
				"                                            tdh.idle_num\r\n" + 
				"                                         end,\r\n" + 
				"                                         0)) as 闲置,\r\n" + 
				"                   sum(nvl(case\r\n" + 
				"                             when tdh.country = '国内' then\r\n" + 
				"                              tdh.repairing_num\r\n" + 
				"                           end,\r\n" + 
				"                           0)) + sum(nvl(case\r\n" + 
				"                                           when tdh.country = '国外' then\r\n" + 
				"                                            tdh.repairing_num\r\n" + 
				"                                         end,\r\n" + 
				"                                         0)) as 在修,\r\n" + 
				"                   sum(nvl(case\r\n" + 
				"                             when tdh.country = '国内' then\r\n" + 
				"                              tdh.wait_repair_num\r\n" + 
				"                           end,\r\n" + 
				"                           0)) + sum(nvl(case\r\n" + 
				"                                           when tdh.country = '国外' then\r\n" + 
				"                                            tdh.wait_repair_num\r\n" + 
				"                                         end,\r\n" + 
				"                                         0)) as 待修,\r\n" + 
				"                   sum(nvl(case\r\n" + 
				"                             when tdh.country = '国内' then\r\n" + 
				"                              tdh.wait_scrap_num\r\n" + 
				"                           end,\r\n" + 
				"                           0)) + sum(nvl(case\r\n" + 
				"                                           when tdh.country = '国外' then\r\n" + 
				"                                            tdh.wait_scrap_num\r\n" + 
				"                                         end,\r\n" + 
				"                                         0)) as 待报废,\r\n" + 
				"                   sum(nvl(case\r\n" + 
				"                             when tdh.country = '国内' then\r\n" + 
				"                              tdh.onway_num\r\n" + 
				"                           end,\r\n" + 
				"                           0)) + sum(nvl(case\r\n" + 
				"                                           when tdh.country = '国外' then\r\n" + 
				"                                            tdh.onway_num\r\n" + 
				"                                         end,\r\n" + 
				"                                         0)) as 在途\r\n" + 
				"              from dms_device_tree dt\r\n" + 
				"              left join (select *\r\n" + 
				"                          from gms_device_dailyhistory dh\r\n" + 
				"                         where dh.bsflag = '0'\r\n" + 
				"                           and dh.country in ('国内', '国外')\r\n" + 
				"                              -- and  account_stat = '0110000013000000003'\r\n" + 
				"                           and dh.his_date =\r\n" + 
				"                               (select max(te.his_date)\r\n" + 
				"                                  from gms_device_dailyhistory te\r\n" + 
				"                                 where te.bsflag = '0')\r\n" + 
				"                        --and dh.org_subjection_id like 'C105%'\r\n" + 
				"                        ) tdh\r\n" + 
				"                on tdh.device_type = dt.device_code\r\n" + 
				"             where dt.bsflag = '0'\r\n" + 
				"             group by orgsubidtoshortid(tdh.org_subjection_id),\r\n" + 
				"                      substr(dt.dev_tree_id, 1, 4)) t\r\n" + 
				"      left join dms_device_tree d\r\n" + 
				"        on t.device_code = d.dev_tree_id\r\n" + 
				"      left join sys_organization s\r\n" + 
				"        on s.org_code = t.org_code\r\n" + 
				"     order by d.code_order ";

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE;

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
