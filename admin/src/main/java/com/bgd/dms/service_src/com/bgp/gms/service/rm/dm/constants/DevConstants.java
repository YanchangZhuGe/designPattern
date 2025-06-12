package com.bgp.gms.service.rm.dm.constants;

public interface DevConstants {
	/** 超级管理员登录名 */
	public static final String COMM_USER_SUPERADMIN = "superadmin";
	/** 数据状态：0-已保存状态 */
	public static final String STATE_SAVED = "0";
	/** 数据状态：9-已提交状态 */
	public static final String STATE_SUBMITED = "9";
	/** 数据状态：已保存状态 */
	public static final String STATEDESC_SAVED = "未提交";
	/** 数据状态：已提交状态 */
	public static final String STATEDESC_SUBMITED = "已提交";
	/** 删除标记：正常 */
	public static final String BSFLAG_NORMAL = "0";
	/** 删除标记：删除 */
	public static final String BSFLAG_DELETE = "1";
	/** 删除标记：转移设备中间状态 */
	public static final String BSFLAG_INTERMEDIATE = "N";
	/** 调拨出库/单据提交 */
	public static final String SAVE_FLAG_1 = "1";
	/** 设备收工验收 */
	public static final String SAVE_FLAG_0 = "0";
	/** 长期闲置标识：0：正常 */
	public static final String IFUNUSED_FLAG_0 = "0";
	/** 长期闲置标识：1：长期闲置 */
	public static final String IFUNUSED_FLAG_1 = "1";
	/** 报废留用设备标记 */
	public static final String IFSCRAPLEFT_FLAG_1 = "1";
	/** 删除标记：新增加 */
	public static final String BSFLAG_NEWADD = "N";
	/** 是否添加明细：是 */
	public static final String ISADDDETAIL_YES = "Y";
	/** 是否添加明细：否 */
	public static final String ISADDDETAIL_NO = "N";
	/** 是否开据调配单：是 */
	public static final String ISPRINTFORM_YES = "Y";
	/** 是否开据调配单：否 */
	public static final String ISPRINTFORM_NO = "N";
	/** S0000 */
	public static final String MIXTYPE_COMMON = "S0000";
	/** S0001 调剂设备 */
	public static final String MIXTYPE_SWAP = "S0001";
	/** S0623 震源*/
	public static final String MIXTYPE_ZHENYUAN = "S0623";
	/** S1405 地震仪器*/
	public static final String MIXTYPE_YIQI = "S1405";
	/** S14059999  地震仪器附属设备*/
	public static final String MIXTYPE_YIQI_FUSHU = "S14059999";
	/** 检波器 */
	public static final String MIXTYPE_JIANBOQI = "S14050208";
	/** 检波器测试仪 */
	public static final String MIXTYPE_JIANBOQICESHIYI = "S14050301";
	/** 小折射仪 */
	public static final String MIXTYPE_XIAOZHESHEYI = "S140504";
	/** 数字检波器 */
	public static final String MIXTYPE_SHUZIJIANBOQI = "S1405020806";
	/** S0622 仪器车，单独拿出来 */
	public static final String MIXTYPE_YIQICHE = "S0622";
	/** S1404 */
	public static final String MIXTYPE_CELIANG = "S1404";
	/** S140401 02 03 */
	public static final String MIXTYPE_CELIANG_01 = "S140401";
	public static final String MIXTYPE_CELIANG_02 = "S140402";
	public static final String MIXTYPE_CELIANG_03 = "S140403";
	/** S9000 批量地震仪器*/
	public static final String MIXTYPE_ZHUANGBEI_DZYQ = "S9000";
	/** S9001 大港自有地震仪器*/
	public static final String MIXTYPE_DAGANG_DZYQ = "S9001";
	/** 装备服务处的设备物资科ORG_ID */
	public static final String MIXTYPE_ZHUANGBEI_ORGID = "C6000000005526";
	/** 装备服务处的的隶属ID */
	public static final String MIXTYPE_ZHUANGBEI_ORGSUBID = "C105006";
	/** 公司级org_sub_id信息 */
	public static final String COMM_COM_ORGSUBID = "C105";
	/** 公司级org_id信息 */
	public static final String COMM_COM_ORGID = "C6000000000001";
	/** 震源服务中心orgid信息 */
	public static final String MIXTYPE_ZHUANGBEI_ZY_ORGID = "C6000000000043";
	/**大港仪器设备服务中心**/
	public static final String MIXTYPE_DAGANG_YQ_ORGID = "C6000000000040";
	/**井中项目类型**/
	public static final String DEV_PROTYPE_JZ = "5000100004000000008";
	/**综合物化探项目类型**/
	public static final String DEV_PROTYPE_ZH = "5000100004000000009";
	/**深海项目类型**/
	public static final String DEV_PROTYPE_SH = "5000100004000000006";
	/**超级管理员用户EMPID**/
	public static final String SUPERADMIN_EMP_ID = "8ad882732f4a003a012f4c7b37d50003";
	/**超级管理员用户登录名**/
	public static final String SUPERADMIN_LOGIN_ID = "superadmin";
	/** 动态信息的标识 1:去项目 2 项目归还 3 待修(采集的维修) 4 在修(采集没有) 5 修好 (维修完成)6无法维修7不需维修*/
	/**设备维修保养类型:保养**/
	public static final String DEV_MAINTAIN_MAINTENANCE = "0110000037000000002";
	/**设备维修保养类型:维修**/
	public static final String DEV_MAINTAIN_REPAIR = "0110000037000000001";
	/**设备维修保养类型:委外处理**/
	public static final String DEV_MAINTAIN_OUT = "0110000037000000003";
	public static final String DYM_OPRTYPE_OUT = "1";
	public static final String DYM_OPRTYPE_IN = "2";
	public static final String DYM_OPRTYPE_WEIXIUOUT = "3";
	public static final String DYM_OPRTYPE_WEIXIUING = "4";
	public static final String DYM_OPRTYPE_WEIXIUIN = "5";
	public static final String DYM_OPRTYPE_WEIXIU_WF = "6";
	public static final String DYM_OPRTYPE_WEIXIU_BX = "7";
	/** 返还的设备类别 */
	public static final String BACK_DEVTYPE_ZIYOU = "S0000";
	public static final String BACK_DEVTYPE_ZHENYUAN = "S0623";
	public static final String BACK_DEVTYPE_YIQI = "S1405";
	public static final String BACK_DEVTYPE_YIQI_FUSHU = "S14059999";
	public static final String BACK_DEVTYPE_CELIANG = "S1404";
	public static final String BACK_DEVTYPE_WAIZU = "S9999";
	public static final String BACK_DEVTYPE_JBQ = "S14050208";
	public static final String BACK_DEVTYPE_ZB_DZYQ = "S9000";
	public static final String BACK_DEVTYPE_DG_DZYQ = "S9001";
	public static final String BACK_DEVTYPE_SWAP = "S0001";
	/** 返还单类型 1:返还申请  2：送修申请  3：更换设备申请   4:返还申请(无需再次调配) */
	public static final String BACK_DEVTYPE_TOBACK = "1";
	public static final String BACK_DEVTYPE_TOREPAIR = "2";
	public static final String BACK_DEVTYPE_TOCHANGE = "3";
	public static final String BACK_DEVTYPE_TONOMIXBACK = "4";
	
	/** 队级台账设备离场   0:未离场  1：已离场  2：离场中 */
	public static final String DEV_LEAVING_NO = "0";
	public static final String DEV_LEAVING_YES = "1";
	public static final String DEV_LEAVING_MID = "2";
	
	/** 队级台账设备转移标识   2：转移中  */
	public static final String DEV_TRANSFER_STATE_MID = "2";
	
	/** 虚拟项目标识  2:虚拟项目*/
	public static final String PROJECT_XN = "2";
	/** 虚拟项目转移到正式项目后gp_task_project表中notes字段的的标识 */
	public static final String PROJECT_DELXN = "DELXN";
	/** 人为主动删除(区别虚拟项目转正式项目删除)虚拟项目后gp_task_project表中notes字段的的标识 */
	public static final String PROJECT_DELXN_MAN = "MANDELXN";
	//陆上地震项目班组
	public static final String TEAM_CELIANG = "0110000001000000001";
	public static final String TEAM_ZHENYUAN = "0110000001000000011";
	public static final String TEAM_YIQI = "0110000001000000018";
	//综合物化探项目班组
	public static final String TEAM_ZH_CELIANG = "0110000001000004701";
	public static final String TEAM_ZH_YIQI = "0110000001000004601";
	//深海项目班组
	public static final String TEAM_SH_YIQI = "0110000001001006201";
	
	/** 接收标识 */
	public static final String DEVRECEIVE_NO = "0";
	public static final String DEVRECEIVEING = "8";
	public static final String DEVRECEIVE = "1";
	/** 离场标识 */
	public static final String DEVLEAVING_NO = "0";
	public static final String DEVLEAVING_YES = "1";
	/** 维修单的类别 */
	public static final String REPAIRTYPE_OUT = "1";
	public static final String REPAIRTYPE_IN = "2";
	/** 设备类别信息(报停) */
	public static final String OS_DANTAI = "1";
	public static final String OS_PILIANG = "2";
	/** 设备技术状态 */
	public static final String DEV_TECH_WANHAO = "0110000006000000001";
	public static final String DEV_TECH_DAIXIU = "0110000006000000006";
	public static final String DEV_TECH_DAIBAOFEI = "0110000006000000005";
	/** 设备使用状态 */
	public static final String DEV_USING_ZAIYONG = "0110000007000000001";
	public static final String DEV_USING_XIANZHI = "0110000007000000002";
	public static final String DEV_USING_TINGYONG = "0110000007000000003";
	public static final String DEV_USING_QITA = "0110000007000000006";
	/** 设备资产状态 */
	public static final String DEV_ACCOUNT_BAOFEI = "0110000013000000001";
	public static final String DEV_ACCOUNT_CHUZHI = "0110000013000000002";
	public static final String DEV_ACCOUNT_ZAIZHANG = "0110000013000000003";
	public static final String DEV_ACCOUNT_HEBING = "0110000013000000004";
	public static final String DEV_ACCOUNT_WAIZU = "0110000013000000005";
	public static final String DEV_ACCOUNT_BUZAIZHANG = "0110000013000000006";
	/** 维修工单状态 在修、待修、结算、完成*/
	public static final String DEV_REPAIR_STATUS_DAIXIU = "5110000225000000001";
	public static final String DEV_REPAIR_STATUS_ZAIXIU = "5110000225000000002";
	public static final String DEV_REPAIR_STATUS_WANCHENG = "5110000225000000003";
	public static final String DEV_REPAIR_STATUS_JIESUAN = "5110000225000000004";
	/** 维修级别: 601：大修 602：小修 603：项修  604：技改 605：保养  606：坞修  
	 *  607：一级维护保养  608：二级维护保养  609：三级维护保养 610：机加工*/
	public static final String DEV_REPAIR_LEVEL_DAXIU = "601";
	public static final String DEV_REPAIR_LEVEL_XIAOXIU = "602";
	public static final String DEV_REPAIR_LEVEL_XIANGXIU = "603";
	public static final String DEV_REPAIR_LEVEL_JIGAI = "604";
	public static final String DEV_REPAIR_LEVEL_BAOYANG = "605";
	public static final String DEV_REPAIR_LEVEL_WUXIU = "606";
	public static final String DEV_REPAIR_LEVEL_YIJIBY = "607";
	public static final String DEV_REPAIR_LEVEL_ERJIBY = "608";
	public static final String DEV_REPAIR_LEVEL_SANJIBY = "609";
	public static final String DEV_REPAIR_LEVEL_JIJIAGONG = "610";
	/** 维修类型  自修、内修、外修、其他 */
	public static final String DEV_REPAIR_TYPE_ZIXIU = "0100400027000000003";
	public static final String DEV_REPAIR_TYPE_NEIXIU = "0100400027000000001";
	public static final String DEV_REPAIR_TYPE_WAIXIU = "0100400027000000002";
	public static final String DEV_REPAIR_TYPE_QITA = "0100400027000000004";
	/** 维修保养数据来源  数据来源  SAP:来自SAP WTSC：平台录入  YD：来自手持机*/
	public static final String DEV_REPAIR_DATAFROM_SAP = "SAP";
	public static final String DEV_REPAIR_DATAFROM_YD = "YD";
	public static final String DEV_REPAIR_DATAFROM_WTSC = "WTSC";
	/** 维修项目: 001：发动机 002：变速箱 003：分动箱  004：前桥 005：中桥  006：后桥 
	 *  007：车身悬挂及车架  008：电路  009：刹车系统 010：空压机
	 *  011：泥浆泵  012：动力头  013：井架  014：液压系统  015：变扭器与离合器
	 *  016：履带   017：轮胎   018：滤芯   019：小油品   020：仪器仪表   021：其它*/
	public static final String DEV_REPAIR_ITEM_FDJ = "001";
	public static final String DEV_REPAIR_ITEM_BSX = "002";
	public static final String DEV_REPAIR_ITEM_FDX = "003";
	public static final String DEV_REPAIR_ITEM_QQ = "004";
	public static final String DEV_REPAIR_ITEM_ZQ = "005";
	public static final String DEV_REPAIR_ITEM_HQ = "006";
	public static final String DEV_REPAIR_ITEM_CSXGJCJ = "007";
	public static final String DEV_REPAIR_ITEM_DL = "008";
	public static final String DEV_REPAIR_ITEM_SC = "009";
	public static final String DEV_REPAIR_ITEM_KYJ = "010";
	public static final String DEV_REPAIR_ITEM_NJB = "011";
	public static final String DEV_REPAIR_ITEM_DLT = "012";
	public static final String DEV_REPAIR_ITEM_JJ = "013";
	public static final String DEV_REPAIR_ITEM_YY = "014";
	public static final String DEV_REPAIR_ITEM_BNQLHQ = "015";
	public static final String DEV_REPAIR_ITEM_LD = "016";
	public static final String DEV_REPAIR_ITEM_LT = "017";
	public static final String DEV_REPAIR_ITEM_LX = "018";
	public static final String DEV_REPAIR_ITEM_XYP = "019";
	public static final String DEV_REPAIR_ITEM_YQYB = "020";
	public static final String DEV_REPAIR_ITEM_QT = "021";
	/** 生产设备和非生产设备标识 */
	public static final String DEV_PRODUCTION_YES = "5110000186000000001";
	public static final String DEV_PRODUCTION_NO = "5110000186000000002";
	/**设备国内/国外标识**/
	public static final String DEV_IFCOUNTRY_GUONEI = "国内";
	public static final String DEV_IFCOUNTRY_GUOWAI = "国外";
	/** 基准时间 */
	public static final String DEV_FORMAT_DATE = "2006-01-01";
	/** 设备送修单状态 */
	public static final String DEV_REPAIR_BIANZHI = "0";
	public static final String DEV_REPAIR_SHENGXIAO = "1";
	public static final String DEV_REPAIR_ZUOFEI = "2";
	public static final String DEV_REPAIR_JUJIESHOU = "3";
	/** 送修类别  维修单类型 0送内维修  1送外维修 */
	public static final String DEV_REPAIR_TYPE_IN = "0";
	public static final String DEV_REPAIR_TYPE_OUT = "1";
	/** 送修设备接收 接收状态0待接收、1接收完成、2拒接收*/
	public static final String DEV_REPAIR_RECEIVE_DAIJIESHOU = "0";
	public static final String DEV_REPAIR_RECEIVE_YIJIESHOU = "1";
	public static final String DEV_REPAIR_RECEIVE_JUJIESHOU = "2";
	/** 送内维修 派工明细     生效状态  数据状态 0生效  1失效 */
	public static final String DEV_REPAIR_DISPATCH_ENABLE = "0";
	public static final String DEV_REPAIR_DISPATCH_DISABLE = "1";
	/**送内维修 派工状态 ASSIGNSTATE  0：待派工 1已派工 **/
	public static final String DEV_REPAIR_ASSIGNSTATE0 = "0";
	public static final String DEV_REPAIR_ASSIGNSTATE1 = "1";
	/**送内维修 派工接收状态  RECIEVESTATE  0待接收 1已接收 2拒接收 **/
	public static final String DEV_REPAIR_RECIEVESTATE0 = "0";
	public static final String DEV_REPAIR_RECIEVESTATE1 = "1";
	public static final String DEV_REPAIR_RECIEVESTATE2 = "2";
	/**送内维修 派工设备状态  DEVSTATUS 0待修 1维修中 2待检测 3无法维修 4维修完成 5不需维修**/
	public static final String DEV_REPAIR_DEVSTATUS0 = "0";
	public static final String DEV_REPAIR_DEVSTATUS1 = "1";
	public static final String DEV_REPAIR_DEVSTATUS2 = "2";
	public static final String DEV_REPAIR_DEVSTATUS3 = "3";
	public static final String DEV_REPAIR_DEVSTATUS4 = "4";
	public static final String DEV_REPAIR_DEVSTATUS5 = "5";
	/**送内维修 派工维修状态  REPAIRSTATE 0待修 1维修中 2待检测 3无法维修 4维修完成 5不需维修**/
	public static final String DEV_REPAIR_REPAIRSTATE0 = "0";
	public static final String DEV_REPAIR_REPAIRSTATE1 = "1";
	public static final String DEV_REPAIR_REPAIRSTATE2 = "2";
	public static final String DEV_REPAIR_REPAIRSTATE3 = "3";
	public static final String DEV_REPAIR_REPAIRSTATE4 = "4";
	public static final String DEV_REPAIR_REPAIRSTATE5 = "5";
	/***decode  key**/
	public static final String DECODE_KEY_ERRORTYPE = "errortype";
	public static final String DECODE_KEY_DEVSTATUS = "devstatus";
	public static final String DECODE_KEY_CURRENCY = "currency";
	public static final String DECODE_KEY_ERRORDESC = "errordesc";
	public static final String DECODE_KEY_REPAIRSTATUS = "repairstatus";
	
	/**RFID设备动态类型**/
	/**调配出库**/
	public static final String RFID_DEV_DYM_OUT_TYPE_TPCK = "0";
	/**送内维修出库**/
	public static final String RFID_DEV_DYM_OUT_TYPE_SNWX = "1";
	/**送外维修出库**/
	public static final String RFID_DEV_DYM_OUT_TYPE_SWWX = "2";
	/**转移出库**/
	public static final String RFID_DEV_DYM_OUT_TYPE_ZYCK = "3";
	/**抵修出库**/
	public static final String RFID_DEV_DYM_OUT_TYPE_DXCK = "4";
	/**调配入库**/
	public static final String RFID_DEV_DYM_IN_TYPE_TPRK = "0";
	/**送内维修入库**/
	public static final String RFID_DEV_DYM_IN_TYPE_SNWX = "1";
	/**送外维修入库**/
	public static final String RFID_DEV_DYM_IN_TYPE_SWWX = "2";
	/**转移入库**/
	public static final String RFID_DEV_DYM_IN_TYPE_ZYCK = "3";
	/**维修返还入库**/
	public static final String RFID_DEV_DYM_IN_TYPE_WXFH = "4";
	
	/**DMS完好率编码**/
	public static final String DMS_ASSESS_PERFECT_RATE = "5110000191000000001";
	/**DMS利用率编码**/
	public static final String DMS_ASSESS_USE_RATE = "5110000191000000002";
	/**DMS考核指标父编码**/
	public static final String DMS_ASSESS_FATHER_CODE = "5110000191";
	/**DMS考核国内标识编码**/
	public static final String DMS_ASSESS_INCOUNTRY = "5110000195000000001";
	/**DMS考核国外标识编码**/
	public static final String DMS_ASSESS_OUTCOUNTRY = "5110000195000000002";
	
	/**DMS考核模板类型:物探处**/
	public static final String DMS_ASSESS_MODEL_TYPE_WTC = "5110000198000000004";
	/**DMS考核模板类型:装备服务处**/
	public static final String DMS_ASSESS_MODEL_TYPE_ZB = "5110000198000000005";
	/**DMS要素审核父编码**/
	public static final String DMS_ASSESS_PLAT_FATHER_CODE = "5110000198";
	/**DMS要素审核级别编码**/
	public static final String DMS_ASSESS_PLAT_LEVEL_0 = "0";
	/**DMS要素审核级别编码**/
	public static final String DMS_ASSESS_PLAT_NOTE_R = "R";
	/**DMS要素审核级别编码**/
	public static final String DMS_ASSESS_PLAT_NOTE_S = "S";
	
	/**DMS首页考核物探处编码-塔里木物探处**/
	public static final String DMS_INDICATORE_TLMWTC_CODE = "tlmwtc";
	public static final String DMS_INDICATORE_TLMWTC_SUB_ID = "C105001005";
	public static final String DMS_INDICATORE_TLMWTC_ORG_ID = "C6000000000010";
	/**DMS首页考核物探处编码-新疆物探处**/
	public static final String DMS_INDICATORE_XJWTC_CODE = "xjwtc";
	public static final String DMS_INDICATORE_XJWTC_SUB_ID = "C105001002";
	public static final String DMS_INDICATORE_XJWTC_ORG_ID = "C6000000000011";
	/**DMS首页考核物探处编码-吐哈物探处**/
	public static final String DMS_INDICATORE_THWTC_CODE = "thwtc";
	public static final String DMS_INDICATORE_THWTC_SUB_ID = "C105001003";
	public static final String DMS_INDICATORE_THWTC_ORG_ID = "C6000000000013";
	/**DMS首页考核物探处编码-青海物探处**/
	public static final String DMS_INDICATORE_QHWTC_CODE = "qhwtc";
	public static final String DMS_INDICATORE_QHWTC_SUB_ID = "C105001004";
	public static final String DMS_INDICATORE_QHWTC_ORG_ID = "C6000000000012";
	/**DMS首页考核物探处编码-长庆物探处**/
	public static final String DMS_INDICATORE_CQWTC_CODE = "cqwtc";
	public static final String DMS_INDICATORE_CQWTC_SUB_ID = "C105005004";
	public static final String DMS_INDICATORE_CQWTC_ORG_ID = "C6000000000045";
	/**DMS首页考核物探处编码-深海物探处**/
	public static final String DMS_INDICATORE_DGWTC_CODE = "dgwtc";
	public static final String DMS_INDICATORE_DGWTC_SUB_ID = "C105007";
	public static final String DMS_INDICATORE_DGWTC_ORG_ID = "C6000000000008";
	/**DMS首页考核物探处编码-辽河物探处**/
	public static final String DMS_INDICATORE_LHWTC_CODE = "lhwtc";
	public static final String DMS_INDICATORE_LHWTC_SUB_ID = "C105063";
	public static final String DMS_INDICATORE_LHWTC_ORG_ID = "C6000000001888";
	/**DMS首页考核物探处编码-华北物探处**/
	public static final String DMS_INDICATORE_HBWTC_CODE = "hbwtc";
	public static final String DMS_INDICATORE_HBWTC_SUB_ID = "C105005000";
	public static final String DMS_INDICATORE_HBWTC_ORG_ID = "C0000000000232";
	/**DMS首页考核物探处编码-新兴物探开发处**/
	public static final String DMS_INDICATORE_XXWTKFC_CODE = "xxwtkfc";
	public static final String DMS_INDICATORE_XXWTKFC_SUB_ID = "C105005001";
	public static final String DMS_INDICATORE_XXWTKFC_ORG_ID = "C6000000000060";
	/**DMS首页考核物探处编码-综合物化探处**/
	public static final String DMS_INDICATORE_ZHWHTC_CODE = "zhwhtc";
	public static final String DMS_INDICATORE_ZHWHTC_SUB_ID = "C105008";
	public static final String DMS_INDICATORE_ZHWHTC_ORG_ID = "C6000000000009";
	/**DMS首页考核物探处编码-西南物探处**/
	public static final String DMS_INDICATORE_XNWTC_CODE = "xnwtc";
	public static final String DMS_INDICATORE_XNWTC_SUB_ID = "C105087";
	public static final String DMS_INDICATORE_XNWTC_ORG_ID = "C6000000008010";
	/**DMS首页考核物探处编码-大庆物探一公司**/
	public static final String DMS_INDICATORE_DQYGS_CODE = "dqygs";
	public static final String DMS_INDICATORE_DQYGS_SUB_ID = "C105092";
	public static final String DMS_INDICATORE_DQYGS_ORG_ID = "C6000000008170";
	/**DMS首页考核物探处编码-大庆物探二公司**/
	public static final String DMS_INDICATORE_DQEGS_CODE = "dqegs";
	public static final String DMS_INDICATORE_DQEGS_SUB_ID = "C105093";
	public static final String DMS_INDICATORE_DQEGS_ORG_ID = "C6000000008171";
	/**DMS首页考核物探处编码-装备服务处**/
	public static final String DMS_INDICATORE_ZBFWC_CODE = "zbfwc";
	public static final String DMS_INDICATORE_ZBFWC_SUB_ID = "C105006";
	public static final String DMS_INDICATORE_ZBFWC_ORG_ID = "C6000000000007";
	/**DMS首页考核物探处编码-国际勘探事业部**/
	public static final String DMS_INDICATORE_GJKTSYB_CODE = "gjktsyb";
	public static final String DMS_INDICATORE_GJKTSYB_SUB_ID = "C105002";
	public static final String DMS_INDICATORE_GJKTSYB_ORG_ID = "C6000000000003";
	/**DMS首页考核物探处编码-深海物探处**/
	public static final String DMS_INDICATORE_SHWTC_CODE = "shwtc";
	public static final String DMS_INDICATORE_SHWTC_SUB_ID = "C105086";
	public static final String DMS_INDICATORE_SHWTC_ORG_ID = "C0000000000234";
	
	/**DMS首页考核装备服务处编码-仪器服务中心**/
	public static final String DMS_INDICATORE_YQFWZX_CODE = "yqfwzx";
	public static final String DMS_INDICATORE_YQFWZX_SUB_ID = "C105006002";
	public static final String DMS_INDICATORE_YQFWZX_ORG_ID = "C6000000000042";
	/**DMS首页考核物探处编码-测量服务中心**/
	public static final String DMS_INDICATORE_CLFWZX_CODE = "clfwzx";
	public static final String DMS_INDICATORE_CLFWZX_SUB_ID = "C105006001";
	public static final String DMS_INDICATORE_CLFWZX_ORG_ID = "C6000000000041";
	/**DMS首页考核物探处编码-震源服务中心**/
	public static final String DMS_INDICATORE_ZYFWZX_CODE = "zyfwzx";
	public static final String DMS_INDICATORE_ZYFWZX_SUB_ID = "C105006003";
	public static final String DMS_INDICATORE_ZYFWZX_ORG_ID = "C6000000000043";
	/**DMS首页考核物探处编码-北疆作业部**/
	public static final String DMS_INDICATORE_BJZYB_CODE = "bjzyb";
	public static final String DMS_INDICATORE_BJZYB_SUB_ID = "C105006005";
	public static final String DMS_INDICATORE_BJZYB_ORG_ID = "C6000000005538";
	/**DMS首页考核物探处编码-敦煌作业部**/
	public static final String DMS_INDICATORE_DHZYB_CODE = "dhzyb";
	public static final String DMS_INDICATORE_DHZYB_SUB_ID = "C105006006";
	public static final String DMS_INDICATORE_DHZYB_ORG_ID = "C6000000005543";
	/**DMS首页考核物探处编码-华北作业部**/
	public static final String DMS_INDICATORE_HBZYB_CODE = "hbzyb";
	public static final String DMS_INDICATORE_HBZYB_SUB_ID = "C105006007";
	public static final String DMS_INDICATORE_HBZYB_ORG_ID = "C6000000005547";
	/**DMS首页考核物探处编码-辽河作业部**/
	public static final String DMS_INDICATORE_LHZYB_CODE = "lhzyb";
	public static final String DMS_INDICATORE_LHZYB_SUB_ID = "C105006029";
	public static final String DMS_INDICATORE_LHZYB_ORG_ID = "C6000000007537";
	/**DMS首页考核物探处编码-塔里木作业部**/
	public static final String DMS_INDICATORE_TLMZYB_CODE = "tlmzyb";
	public static final String DMS_INDICATORE_TLMZYB_SUB_ID = "C105006008";
	public static final String DMS_INDICATORE_TLMZYB_ORG_ID = "C6000000005551";
	/**DMS首页考核物探处编码-吐哈作业部**/
	public static final String DMS_INDICATORE_THZYB_CODE = "thzyb";
	public static final String DMS_INDICATORE_THZYB_SUB_ID = "C105006009";
	public static final String DMS_INDICATORE_THZYB_ORG_ID = "C6000000005555";
	/**DMS首页考核物探处编码-新区作业部**/
	public static final String DMS_INDICATORE_XQZYB_CODE = "xqzyb";
	public static final String DMS_INDICATORE_XQZYB_SUB_ID = "C105006011";
	public static final String DMS_INDICATORE_XQZYB_ORG_ID = "C6000000005560";
	/**DMS首页考核物探处编码-长庆作业部**/
	public static final String DMS_INDICATORE_CQZYB_CODE = "cqzyb";
	public static final String DMS_INDICATORE_CQZYB_SUB_ID = "C105006004";
	public static final String DMS_INDICATORE_CQZYB_ORG_ID = "C6000000005534";
	
	/**DMS首页地震队考核明细编码-开工验收**/
	public static final String DMS_INDICATORE_KGYS_CODE = "kgys";
	public static final String DMS_INDICATORE_KGYS_DET_ID = "239EE8BC11C6967BE050580A80F80D22";
	/**DMS首页地震队考核明细编码-保养管理**/
	public static final String DMS_INDICATORE_BYGL_CODE = "bygl";
	public static final String DMS_INDICATORE_BYGL_DET_ID = "239EE8BC11C6967BE050580A80F80D25";
	/**DMS首页地震队考核明细编码-设备考勤**/
	public static final String DMS_INDICATORE_SBKQ_CODE = "sbkq";
	public static final String DMS_INDICATORE_SBKQ_DET_ID = "239EE8BC11C6967BE050580A80F80D26";
	/**DMS首页地震队考核明细编码-定人定机**/
	public static final String DMS_INDICATORE_DRDJ_CODE = "drdj";
	public static final String DMS_INDICATORE_DRDJ_DET_ID = "239EE8BC11C6967BE050580A80F80D27";
	/**DMS首页地震队考核明细编码-运转记录**/
	public static final String DMS_INDICATORE_YZJL_CODE = "yzjl";
	public static final String DMS_INDICATORE_YZJL_DET_ID = "239EE8BC11C6967BE050580A80F80D30";
	/**DMS首页地震队考核明细编码-设备返还**/
	public static final String DMS_INDICATORE_SBFH_CODE = "sbfh";
	public static final String DMS_INDICATORE_SBFH_DET_ID = "239EE8BC11C6967BE050580A80F80D23";
	/**DMS首页地震队考核明细编码-收工验收**/
	public static final String DMS_INDICATORE_SGYS_CODE = "sgys";
	public static final String DMS_INDICATORE_SGYS_DET_ID = "239EE8BC11C6967BE050580A80F80D24";
	/**DMS首页地震队考核明细编码-特种设备管理**/
	public static final String DMS_INDICATORE_TZSBGL_CODE = "tzsbgl";
	public static final String DMS_INDICATORE_TZSBGL_DET_ID = "239EE8BC11C6967BE050580A80F80D33";
	/**DMS首页地震队考核明细编码-地震仪器盘亏**/
	public static final String DMS_INDICATORE_DZYQPK_CODE = "dzyqpk";
	public static final String DMS_INDICATORE_DZYQPK_DET_ID = "239EE8BC11C6967BE050580A80F80E34";
	/**DMS首页地震队考核明细编码-地震仪器毁损**/
	public static final String DMS_INDICATORE_DZYQHS_CODE = "dzyqhs";
	public static final String DMS_INDICATORE_DZYQHS_DET_ID = "239EE8BC11C6967BE050580A80F80E35";
	/**DMS设备体系系统登录日志系统标识**/
	public static final String LOG_LOGIN_SYS_DMS = "DMS";
	/**GMS项目管理系统登录日志系统标识**/
	public static final String LOG_LOGIN_SYS_GMS = "GMS";
	/**系统登录日志:系统登录类型 PC端登陆**/
	public static final String LOG_LOGIN_TYPE_PC = "PC";
	/**系统登录日志:系统登录类型 瑞信端登陆**/
	public static final String LOG_LOGIN_TYPE_RX = "RX";
	/**系统登录日志:系统登录描述**/
	public static final String LOG_LOGIN_DESC = "登录";
	/**审批流区分标志:项目管理系统模板coding_sort_id(用于区分项目管理系统和设备体系系统)**/
	public static final String WORK_FLOW_CODE_GMS = "5110000004";
	/**审批流区分标志:设备体系系统模板coding_sort_id(用于区分项目管理系统和设备体系系统)**/
	public static final String WORK_FLOW_CODE_DMS = "5110000181";
}
