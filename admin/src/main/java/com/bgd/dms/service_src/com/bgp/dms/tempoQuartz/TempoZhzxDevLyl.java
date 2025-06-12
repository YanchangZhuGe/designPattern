package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//类名对应数据库表名
public class TempoZhzxDevLyl {

	private static String TABLE = "tempo_zhzx_dev_lyl";

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

		String sqString = "delete from " + TABLE + "  where his_date > sysdate - 15 ";
		jdbcDao.executeUpdate(sqString);
	}

	// 保存数据
	public void save() {

		String tableName = "  insert into " + TABLE + " ";
		String sqlString = tableName + "    with tabletime as\r\n" + 
				"     (select distinct dt.his_date\r\n" + 
				"        from gms_device_dailyhistory dt\r\n" + 
				"       where 1 = 1\r\n" + 
				"         and dt.his_date <= (select max(dt.his_date)\r\n" + 
				"                               from gms_device_dailyhistory dt\r\n" + 
				"                              where dt.account_stat = '0110000013000000003'\r\n" + 
				"                                and dt.org_subjection_id like 'C105' || '%'\r\n" + 
				"                                and dt.bsflag = '0')\r\n" + 
				"         and dt.his_date >= (\r\n" + 
				"                             \r\n" + 
				"                             select min(dt.his_date)\r\n" + 
				"                               from gms_device_dailyhistory dt\r\n" + 
				"                              where dt.account_stat = '0110000013000000003'\r\n" + 
				"                                and dt.org_subjection_id like 'C105' || '%'\r\n" + 
				"                                and dt.bsflag = '0'))\r\n" + 
				"    \r\n" + 
				"    select t.*, d.device_name as label, s.org_abbreviation\r\n" + 
				"      from (select orgsubidtoshortid(dh.org_subjection_id) as org_code,\r\n" + 
				"                   substr(dt.dev_tree_id, 1, 4) dev_tree_id,\r\n" + 
				"                   dh.his_date,\r\n" + 
				"                   case\r\n" + 
				"                     when cast(round(nvl(decode(sum(dh.sum_num),\r\n" + 
				"                                                0,\r\n" + 
				"                                                0,\r\n" + 
				"                                                (sum(dh.use_num) +\r\n" + 
				"                                                nvl(t.usenum, 0)) /\r\n" + 
				"                                                sum(dh.sum_num)),\r\n" + 
				"                                         0) * 100 * 365 / 250,\r\n" + 
				"                                     2) as number(10, 2)) > 100 then\r\n" + 
				"                      100\r\n" + 
				"                     else\r\n" + 
				"                      cast(round(nvl(decode(sum(dh.sum_num),\r\n" + 
				"                                            0,\r\n" + 
				"                                            0,\r\n" + 
				"                                            (sum(dh.use_num) +\r\n" + 
				"                                            nvl(t.usenum, 0)) /\r\n" + 
				"                                            sum(dh.sum_num)),\r\n" + 
				"                                     0) * 100 * 365 / 250,\r\n" + 
				"                                 2) as number(10, 2))\r\n" + 
				"                   end as userate\r\n" + 
				"              from gms_device_dailyhistory dh\r\n" + 
				"              left join dms_device_tree dt\r\n" + 
				"                on dh.device_type = dt.device_code\r\n" + 
				"              left join (select d.his_date, sum(d.use_num) as usenum\r\n" + 
				"                          from gms_device_dailyhistory d\r\n" + 
				"                          left join dms_device_tree dr\r\n" + 
				"                            on dr.device_code = d.device_type\r\n" + 
				"                         where d.bsflag = '0'\r\n" + 
				"                           and d.account_stat = '0110000013000000001'\r\n" + 
				"                           and d.country = '国内'\r\n" + 
				"                           and d.org_subjection_id like 'C105' || '%'\r\n" + 
				"                         group by d.his_date) t\r\n" + 
				"                on dh.his_date = t.his_date\r\n" + 
				"             where dh.account_stat = '0110000013000000003'\r\n" + 
				"               and dh.ifproduction = '5110000186000000001'\r\n" + 
				"               and dh.bsflag = '0'\r\n" + 
				"               and dh.his_date in (select * from tabletime)\r\n" + 
				"               and dh.country = '国内'\r\n" + 
				"               and dh.org_subjection_id like 'C105' || '%'\r\n" + 
				"             group by substr(dt.dev_tree_id, 1, 4),\r\n" + 
				"                      dh.his_date,\r\n" + 
				"                      t.usenum,\r\n" + 
				"                      orgsubidtoshortid(dh.org_subjection_id)\r\n" + 
				"             order by dh.his_date desc) t\r\n" + 
				"      left join dms_device_tree d\r\n" + 
				"        on t.dev_tree_id = d.dev_tree_id\r\n" + 
				"      left join sys_organization s\r\n" + 
				"        on t.org_code = s.org_code\r\n" + 
				"     where t.his_date > sysdate - 15";

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE +"  where his_date > sysdate - 15 ";

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
