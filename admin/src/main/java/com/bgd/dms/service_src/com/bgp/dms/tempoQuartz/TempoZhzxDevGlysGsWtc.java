package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//类名对应数据库表名
public class TempoZhzxDevGlysGsWtc {

	private static String TABLE = "tempo_zhzx_dev_glys_gs_wtc";

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
		String sqlString = tableName + "    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_bygl t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_sbkq t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_drdj t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_yzjl t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_sbfh t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_sgys t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_zyczspj t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_tzsbgl t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_dzyqpk t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_dzyqsh t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_sbwx t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_rcjc t\r\n" + 
				"    union all\r\n" + 
				"    select t.一级管理要素,\r\n" + 
				"           t.二级管理要素,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.下钻\r\n" + 
				"      from v_sb_glys_sbbfgl t\r\n" ;

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE;

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
