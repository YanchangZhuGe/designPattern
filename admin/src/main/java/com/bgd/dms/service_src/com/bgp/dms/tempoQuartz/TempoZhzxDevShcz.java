package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//类名对应数据库表名
public class TempoZhzxDevShcz {

	private static String TABLE = "tempo_zhzx_dev_shcz";

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
		String sqlString = tableName + " select t.orgname as \"单位名称\",\r\n" + "           t.org_code,\r\n"
				+ "           s.org_abbreviation,\r\n" + "           t.scrape_type as \"报废类型\",\r\n"
				+ "           sum(t.net_value) as \"净值\",\r\n" + "           sum(t.asset_value) as \"原值\"\r\n"
				+ "      from (select orgsubidtoname(account.owning_sub_id) orgname,\r\n"
				+ "                   orgsubidtoshortid(account.owning_sub_id) as org_code,\r\n"
				+ "                   detailed.net_value,\r\n" + "                   detailed.asset_value,\r\n"
				+ "                   case\r\n" + "                     when detailed.scrape_type = '0' then\r\n"
				+ "                      '正常报废'\r\n" + "                     when detailed.scrape_type = '1' then\r\n"
				+ "                      '技术淘汰'\r\n" + "                     when detailed.scrape_type = '2' then\r\n"
				+ "                      '毁损'\r\n" + "                     when detailed.scrape_type = '3' then\r\n"
				+ "                      '盘亏'\r\n" + "                   end as scrape_type\r\n"
				+ "              from dms_scrape_detailed detailed\r\n"
				+ "              left join gms_device_account account\r\n"
				+ "                on account.dev_acc_id = detailed.foreign_dev_id\r\n"
				+ "             where detailed.handle_flag is not null\r\n"
				+ "               and detailed.bsflag = '0') t\r\n" + "      left join sys_organization s\r\n"
				+ "        on t.org_code = s.org_code\r\n" + "     where t.orgname is not null\r\n"
				+ "       and t.scrape_type is not null\r\n"
				+ "     group by t.orgname, t.scrape_type, t.org_code, s.org_abbreviation";

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE;

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
