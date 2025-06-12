package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//类名对应数据库表名
public class TempoZhzxDevWhl {

	private static String TABLE = "tempo_zhzx_dev_whl";

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
		String sqlString = tableName + "select t.*, d.device_name as label, s.org_abbreviation\r\n" + 
				"      from (select orgsubidtoshortid(dh.org_subjection_id) as org_code,\r\n" + 
				"                   substr(dt.dev_tree_id, 1, 4) dev_tree_id,\r\n" + 
				"                   dh.his_date as his_date,\r\n" + 
				"                   sum(dh.sum_num) as sum_num, --总数\r\n" + 
				"                   sum(dh.intact_num) as intact_num --完好数\r\n" + 
				"              from dms_device_tree dt\r\n" + 
				"              left join gms_device_dailyhistory dh\r\n" + 
				"                on dh.device_type = dt.device_code\r\n" + 
				"               and dh.bsflag = '0'\r\n" + 
				"               and dh.org_subjection_id like 'C105' || '%'\r\n" + 
				"               and dh.account_stat = '0110000013000000003'\r\n" + 
				"               and dh.ifproduction = '5110000186000000001'\r\n" + 
				"             where dt.bsflag = '0'\r\n" + 
				"               and dh.his_date >=\r\n" + 
				"                   (select min(dt.his_date)\r\n" + 
				"                      from gms_device_dailyhistory dt\r\n" + 
				"                     where dt.account_stat = '0110000013000000003'\r\n" + 
				"                       and dt.org_subjection_id like 'C105' || '%'\r\n" + 
				"                       and dt.bsflag = '0')\r\n" + 
				"               and dh.his_date <=\r\n" + 
				"                   (select max(dt.his_date)\r\n" + 
				"                      from gms_device_dailyhistory dt\r\n" + 
				"                     where dt.account_stat = '0110000013000000003'\r\n" + 
				"                       and dt.org_subjection_id like 'C105' || '%'\r\n" + 
				"                       and dt.bsflag = '0')\r\n" + 
				"             group by substr(dt.dev_tree_id, 1, 4),\r\n" + 
				"                      dh.his_date,\r\n" + 
				"                      orgsubidtoshortid(dh.org_subjection_id)) t\r\n" + 
				"      left join dms_device_tree d\r\n" + 
				"        on t.dev_tree_id = d.dev_tree_id\r\n" + 
				"      left join sys_organization s\r\n" + 
				"        on t.org_code = s.org_code\r\n" + 
				"     where t.his_date > sysdate - 15";

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE;

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
