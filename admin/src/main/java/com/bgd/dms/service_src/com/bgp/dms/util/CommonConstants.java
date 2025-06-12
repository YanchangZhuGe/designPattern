package com.bgp.dms.util;

/*
 * @author zjb
 * @deprecated 设备状态清单常量值说明表
 * */
public interface CommonConstants {
	/** 删除标记：正常 */
	public static final String BSFLAG_NORMAL = "0";
	/** 删除标记：删除 */
	public static final String BSFLAG_DELETE = "1";
	/**
	 * 资产状态（account_stat）<font color="red">报废</font>
	 * */
	public static final String ACCOUNT_STAT_BF = "0110000013000000001";
	/**
	 * 资产状态（account_stat）<font color="red">已处置</font>
	 * */
	public static final String ACCOUNT_STAT_ZCZ = "0110000013000000002";
	/**
	 * 资产状态（account_stat）<font color="red">在账</font>
	 * */
	public static final String ACCOUNT_STAT_ZZ = "0110000013000000003";
	/**
	 * 资产状态（account_stat）<font color="red">已合并</font>
	 * 1、被合并的设备状态为“已合并”，产生的新的状态是“有效”，相应的价值量会在Amis中变更。
	 * 例如：设备1合并到设备2上，设备1的状态是“已合并”，原值、净值为0。设备2的状态是“有效”，原值是两个设备的原值之和。
	 * */
	public static final String ACCOUNT_STAT_YHB = "0110000013000000004";
	/**
	 * 技术状态tech_stat <font color="red">完好</font>
	 *  1、设备"收工验收"产生：完好、待修、待报废、验收状态。
	 * 2、运行管理设备维修模块操作产生"待修"、"在修"、"完好"状态。
	 */
	public static final String TECH_STAT_WH = "0110000006000000001";
	/**
	 * 技术状态tech_stat <font color="red">待报废 </font>
	 * 1、设备"收工验收"产生：完好、待修、待报废、验收状态。
	 * 2、运行管理设备维修模块操作产生"待修"、"在修"、"完好"状态。
	 */
	public static final String TECH_STAT_DBF = "0110000006000000005";
	/**
	 * 技术状态tech_stat <font color="red">待修 </font>
	 * 1、设备"收工验收"产生：完好、待修、待报废、验收状态。
	 * 2、运行管理设备维修模块操作产生"待修"、"在修"、"完好"状态。
	 */
	public static final String TECH_STAT_DX = "0110000006000000006";
	/**
	 * 技术状态tech_stat <font color="red">在修</font>
	 *  1、设备"收工验收"产生：完好、待修、待报废、验收状态。
	 * 2、运行管理设备维修模块操作产生"待修"、"在修"、"完好"状态。
	 */
	public static final String TECH_STAT_ZX = "0110000006000000007";
	/** 技术状态tech_stat <font color="red">验收</font> */
	public static final String TECH_STAT_YS = "0110000006000000013";
	/**
	 * 使用状态using_stat <font color="red">在用</font>
	 *  1、设备被调配或者出库后状态变为"在用"； 
	 *  2、"使用状态"为"在用"时"技术状态"必须为"完好"
	 */
	public static final String USING_STAT_ZY = "0110000007000000001";
	/**
	 * 使用状态using_stat <font color="red"></font>闲置
	 * 1、收工验收完成后变为"闲置"； 
	 * 2、"使用他状态"为"闲置"时"技术状态"必须为"完好"
	 */
	public static final String USING_STAT_XZ = "0110000007000000002";
	/** 使用状态using_stat <font color="red">停用</font> 
	 * 单项目中设备报停计划会使用此状态。审批通过的报停计划在单项目台账中会停用。 */
	public static final String USING_STAT_TY = "0110000007000000003";
	/** 使用状态using_stat <font color="red">其他</font> 使用状态为"其他"，
	 * 是设备"技术状态"应为：待报废、待修、在修、验收； */
	public static final String USING_STAT_QT = "0110000007000000006";
	/** 期闲置标识ifunused <font color="red">正常</font> */
	public static final String IFUNUSED_ZC = "0";
	/** 期闲置标识ifunused <font color="red">长期闲置 </font>
	 * 设备如果一个月内未使用即被标识为 "长期闲置" */
	public static final String IFUNUSED_CQXZ = "1";
	/**
	 * 生产设备标识ifproduction <font color="red">生产设备</font>
	 * 1、装备服务处：仪器车(S0622)、震源(S0623)、工程车(S080401)、皮卡(S080105)；
	 * 2、物探处：钻机(S0601)、卡车(S080101)、皮卡(S080105)、吉普(S080304)、推土机
	 * (S070301)、油水罐车(S08010301,S08010302)、爆破器材运输车(S08010304)；
	 * 3、综合物化探：车辆同物探处，其余设备为非生产设备； 4、大港物探处、国际部：运输船舶为生产设备； 5、批量表数据都为生产设备
	 */
	public static final String IFPRODUCTION_SCSB = "5110000186000000001";
	/**
	 * 生产设备标识ifproduction <font color="red">非生产设备</font>
	 * 1、单位：除装备服务处及各物探处外的其余单位的设备都为非生产设备； 2、设备类型：除生产设备所列的设备类型外其余设备类型均为非生产设备。
	 */
	public static final String IFPRODUCTION_FSCSB = "5110000186000000002";
	/**
	 * 国内/国外标识ifcountry 国内 除国际设备单位编码所列的单位设备均为"国内".
	 */
	public static final String IFCOUNTRY_GN = "国内";
	/**
	 * 国内/国外标识ifcountry 国外 国际设备单位编码所列的单位设备均为"国外".
	 */
	public static final String IFCOUNTRY_GW = "国外";
}
