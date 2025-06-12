package com.bgp.gms.service.rm.dm.util;

import java.util.List;
import java.util.Map;

/**
 * hessian service接口类
 * @author liyongfeng
 *
 */
public interface DevRFIDWebSrv {

	public String testSvr(String name);
	public String testMap(Map<String,Object> m);
	
	/**
	 * 终端登录service
	 * @param username 登录用户名
	 * @param password 登录密码
	 * @return 返回用户对象相关信息
	 */
	public UserInfo clientLogin(String username,String password);
	
	/**
	 * 获得设备类型映射关系
	 * @return 批量设备类型与sap设备类型映射好关系的数据，符合终端数据类型表的数据
	 */
	public List<DevTypeMapping> getDevTypeMapping();
	
	/**
	 * 生成当前批量设备台账数据压缩文件，此数据文件下载完成后，需要调用deleteDevAccountDataFile方法将此数据文件删除
	 * @return 生成的压缩文件名称，如：123.zip，下载时需要在应用url后加上/rm/dm/rfidData，如：http://localhost/gms3/rm/dm/rfidData/123.zip
	 */
	public String createDevAccountDataFile();
	
	/**
	 * 根据文件名删除生成的压缩文件
	 * @param filename 压缩文件名称，如：123.zip
	 */
	public void deleteDevAccountDataFile(String filename);
	
	/**
	 * 下载指定仓库的出库单，状态为未完成的出库单
	 * @param orgid 出库仓库id
	 * @return 出库单
	 */
	public List<RFIDDevOutFormDTO> downloadOutForm(String orgid);
	
	/**
	 * 根据出库单id下载出库单子表数据
	 * @param outformid 出库单id
	 * @return 出库单子表数据
	 */
	public List<RFIDDevOutFormSub> downloadOutFormSub(String outformid);
	
	/**
	 * 根据出库单id下周出库单单台明细数据
	 * @param outformid 出库单id
	 * @return 出库单单台明细数据
	 */
	public List<RFIDDevOutFormSubDetail> downloadOutFormSubDetail(String outformid);
	
	/**
	 * 上传出库单明细数据
	 * @param outFormId 出库单ID
	 * @param detailData 出库单明细
	 * @return {uploadsum(上传总数):10,successsum(成功接收并入库总数):8,errorsum(未成功接收数量，包括重复的):2,'采集站FDU/WP 428'(出库单子表中的出库设备批量类型):'8|2'(已完成|还差)}
	 */
	public Map<String,Object> uploadOutDetail(String outFormId,List<RFIDDevOut> detailData,String userid);
	
	/**
	 * 上传RFID与设备的绑定数据
	 * @param data
	 * @return
	 */
	public Map<String,Object> uploadRFIDBind(List<RFIDBind> data,String orgid);
	
	/**
	 * 根据所在机构下载入库单数据
	 * @param orgid
	 * @return
	 */
	public List<RFIDDevInFormDTO> downloadInForm(String orgid);
	
	/**
	 * 下载入库单子表数据
	 * @param inFormId 入库单主表id
	 * @return
	 */
	public List<RFIDDevInFormSub> downloadInFormSub(String inFormId);
	
	/**
	 * 下载入库单明细设备数据
	 * @param inFormId 入库单id
	 * @return
	 */
	public List<RFIDDevInFormSubDetail> downloadInFormSubDetail(String inFormId);
	
	/**
	 * 上传入库单明细数据
	 * @param outFormId 入库单ID
	 * @param detailData 入库单明细
	 * @return {flag:0/1,msg:提示信息,uploadsum(上传总数):10,successsum(成功接收并入库总数):8,errorsum(未成功接收数量，包括重复的):2,'采集站FDU/WP 428'(入库单子表中的出库设备批量类型):'8|2'(已完成|还差)}
	 */
	public Map<String,Object> uploadInDetail(String inFormId,List<RFIDDevIn> detailData,String userid);
	
	/**
	 * 根据字典类型获得可使用的字典数据
	 * @param enumType 字典类型
	 * @return
	 */
	public List<EnumEntity> downloadEnum(String enumType);
	
	/**
	 * 根据orgid下载送外维修单   根据送修单位  liug  union 已经返还了的送外维修单
	 * @param orgid 出库机构id(查找编制状态的送修单 并返回)
	 * @return
	 */
	public List<GmsDeviceCollRepairSend> downloadVendorRepairForm(String orgid);
	
	/**
	 * 根据orgid下载送内维修单  根据送修单位  liug  union 已经返还了的送内维修单
	 * @param orgid 出库机构id
	 * @return
	 */
	public List<GmsDeviceCollRepairform> downloadSelfRepairForm(String orgid);
	
	/**
	 * 根据维修单号下载送外维修单   根据送修单位  liug  union 已经返还了的送外维修单
	 * @param rtnid 维修返还单ID
	 * @return
	 */
	public List<GmsDeviceCollRepairSend> downloadVendorRepairFormByRtnId(String rtnid);
	
	/**
	 * 根据维修单号下载送内维修单  根据送修单位  liug  union 已经返还了的送内维修单
	 * @param rtnid 维修返还单ID
	 * @return
	 */
	public List<GmsDeviceCollRepairform> downloadSelfRepairFormByRtnId(String rtnid);
	
	/**
	 * 根据orgid下载维修返还单  
	 * @param ogrid 接收机构id
	 * @return   //根据送修单位 下载维修返还单
	 */
	public List<GmsDeviceDolRepForm> downloadReturnRepairForm(String ogrid);
	
	/**
	 * 上传送外维修单明细数据
	 * @param formId 维修单id
	 * @param data 明细数据
	 * @return {'flag':'0/1','msg':'文字提示信息',uploadsum(上传总数):10,successsum(成功接收并入库总数):8,errorsum(未成功接收数量，包括重复的):2}
	 */
	public Map<String,Object> uploadVendorRepairFormDetail(String formId,List<GmsDeviceCollSendSub> data);
	
	/**
	 * 上传松内维修单明细数据
	 * @param formId 维修单id
	 * @param data 明细数据
	 * @return {'flag':'0/1','msg':'文字提示信息',uploadsum(上传总数):10,successsum(成功接收并入库总数):8,errorsum(未成功接收数量，包括重复的):2}
	 */
	public Map<String,Object> uploadSelfRepairFormDetail(String formId,List<GmsDeviceCollRepairSub> data);
	
	/**
	 * 上传维修返还明细数据
	 * @param formId 返还单ID
	 * @return {'flag':'0/1','msg':'文字提示信息',uploadsum(上传总数):10,successsum(成功接收并入库总数):8,errorsum(未成功接收数量，包括重复的):2}
	 */
	public Map<String,Object> uploadReturnRepairFormDetail(String formId,List<GmsDeviceColRepDetail> data);
	
	/**
	 * 根据id下载送外维修单 明细
	 * @param 维修单id
	 * @return
	 */
	public List<GmsDeviceCollSendSub> downloadVendorRepairFormSub(String id);
	
	/**
	 * 根据id下载送内维修单 明细
	 * @param id 维修单id
	 * @return
	 */
	public List<GmsDeviceCollRepairSub> downloadSelfRepairFormSub(String id);
	
	/**
	 * 根据id下载维修返还单 明细
	 * @param id 返还单id
	 * @return   
	 */
	public List<GmsDeviceColRepDetail> downloadReturnRepairFormSub(String id);
	
	/**
	 * 获得服务器当前时间
	 * @return 2014-8-24 17:30:51
	 */
	public String getServerTime();
}
