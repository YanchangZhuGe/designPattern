package com.bgp.gms.service.rm.dm;

import com.cnpc.jcdp.soa.msg.ISrvMsg;

/**
 * 设备相关接口服务
 */
public interface IWtcDevSrv {
		/**
		 * 调配自有单台设备及检波器设备保存gms_device_mixinfo_form
		 * @param msg
		 * @param devType 设备类型：DT:单台 JBQ：检波器 COLL:地震仪器
		 * @return  返回调配单主键
		 */
		public String saveDevMixForm(ISrvMsg msg,String devType)throws Exception;
		/**
		 * 调配外租单台及检波器设备保存gms_device_hireapp
		 * @param msg
		 * @param 
		 * @return  返回外租设备单据主键
		 */
		public String saveHireDevApp(ISrvMsg msg)throws Exception;
		/**
		 * 设备报停计划保存gms_device_osapp
		 * @param msg
		 * @param 
		 * @return  返回是被报停计划单主键
		 */
		public String saveDevOsApp(ISrvMsg msg)throws Exception;
		/**
		 * 设备转移保存gms_device_move
		 * @param msg
		 * @param dcFlag 设备类型：DT:单台 COLL：批量
		 * @return  返回转移单据主键
		 */
		public String saveMovDevApp(ISrvMsg msg,String dcFlag)throws Exception;
		/**
		 * 设备返还单台保存gms_device_backapp
		 * @param msg
		 * @param 
		 * @return  返回设备返还单据主键
		 */
		public String saveBackDevApp(ISrvMsg msg)throws Exception;
		/**
		 * 批量保存设备档案
		 * @param msg
		 * @param
		 * @return  成功返回空值，失败返回错误码
		 */
		public String saveDevArchive(ISrvMsg msg)throws Exception;
		/**
		 * 虚拟项目转正式项目批量修改设备档案项目编号
		 * @param msg
		 * @param
		 * @return  成功返回空值，失败返回错误码
		 */
		public String saveVirProDevArchive(ISrvMsg msg)throws Exception;
		/**
		 * 虚拟项目转正式项目判断设备是否全部转移
		 * @param outProjectNo 转出项目编号
		 * @param
		 * @return  成功返回true，失败返回flase
		 */
		public boolean opVirProDev(String outProjectNo)throws Exception;
		/**
		 * 接收外租单台、地震仪器及检波器设备保存gms_device_hireapp
		 * @param msg
		 * @param 
		 * @return  返回外租设备单据主键
		 */
		public String saveHireDevAppNew(ISrvMsg msg)throws Exception;
}
