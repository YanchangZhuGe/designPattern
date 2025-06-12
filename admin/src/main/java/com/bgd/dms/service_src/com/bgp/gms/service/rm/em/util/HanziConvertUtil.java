package com.bgp.gms.service.rm.em.util;

import java.io.UnsupportedEncodingException;

/*
 * author:邱庆豹
 * 
 * date:2010-8-5
 * 
 * 描述:获取汉字拼音码
 * 
 */
public class HanziConvertUtil {

	
	private static final String gbRule = "GB2312";

	// 汉字区位码
	private static final int li_FirstPinyinValue[] = { 1601, 1637, 1833, 2078,
			2274, 2302, 2433, 2594, 2787, 3106, 3212, 3472, 3635, 3722, 3730,
			3858, 4027, 4086, 4390, 4558, 4684, 4925, 5249, 5590 };
	// 存放国标一级汉字不同读音的起始区位码对应读音
	private static final char lc_FirstPinyinValue[] = { 'A', 'B', 'C', 'D', 'E',
			'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S',
			'T', 'W', 'X', 'Y', 'Z' };
	// 存放拼音码分割对应的区位码
	private static final int li_pinyinValue[] = { -20319, -20317, -20304,
			-20295, -20292, -20283, -20265, -20257, -20242, -20230, -20051,
			-20036, -20032, -20026, -20002, -19990, -19986, -19982, -19976,
			-19805, -19784, -19775, -19774, -19763, -19756, -19751, -19746,
			-19741, -19739, -19728, -19725, -19715, -19540, -19531, -19525,
			-19515, -19500, -19484, -19479, -19467, -19289, -19288, -19281,
			-19275, -19270, -19263, -19261, -19249, -19243, -19242, -19238,
			-19235, -19227, -19224, -19218, -19212, -19038, -19023, -19018,
			-19006, -19003, -18996, -18977, -18961, -18952, -18783, -18774,
			-18773, -18763, -18756, -18741, -18735, -18731, -18722, -18710,
			-18697, -18696, -18526, -18518, -18501, -18490, -18478, -18463,
			-18448, -18447, -18446, -18239, -18237, -18231, -18220, -18211,
			-18201, -18184, -18183, -18181, -18012, -17997, -17988, -17970,
			-17964, -17961, -17950, -17947, -17931, -17928, -17922, -17759,
			-17752, -17733, -17730, -17721, -17703, -17701, -17697, -17692,
			-17683, -17676, -17496, -17487, -17482, -17468, -17454, -17433,
			-17427, -17417, -17202, -17185, -16983, -16970, -16942, -16915,
			-16733, -16708, -16706, -16689, -16664, -16657, -16647, -16474,
			-16470, -16465, -16459, -16452, -16448, -16433, -16429, -16427,
			-16423, -16419, -16412, -16407, -16403, -16401, -16393, -16220,
			-16216, -16212, -16205, -16202, -16187, -16180, -16171, -16169,
			-16158, -16155, -15959, -15958, -15944, -15933, -15920, -15915,
			-15903, -15889, -15878, -15707, -15701, -15667, -15661, -15659,
			-15652, -15681, -15640, -15631, -15625, -15454, -15448, -15436,
			-15435, -15419, -15416, -15408, -15394, -15385, -15377, -15375,
			-15369, -15363, -15362, -15183, -15180, -15165, -15158, -15153,
			-15150, -15149, -15144, -15143, -15141, -15140, -15139, -15128,
			-15121, -15119, -15117, -15110, -15109, -14941, -14937, -14933,
			-14929, -14928, -14926, -14930, -14922, -14921, -14914, -14908,
			-14902, -14894, -14889, -14882, -14873, -14871, -14857, -14678,
			-14674, -14670, -14668, -14663, -14654, -14645, -14630, -14594,
			-14429, -14407, -14399, -14384, -14379, -14368, -14355, -14353,
			-14345, -14170, -14159, -14151, -14149, -14145, -14140, -14137,
			-14135, -14125, -14123, -14122, -14112, -14109, -14099, -14097,
			-14094, -14092, -14090, -14087, -14083, -13917, -13914, -13910,
			-13907, -13906, -13905, -13896, -13894, -13878, -13870, -13859,
			-13847, -13831, -13658, -13611, -13601, -13406, -13404, -13400,
			-13398, -13395, -13391, -13387, -13383, -13367, -13359, -13356,
			-13343, -13340, -13329, -13326, -13318, -13147, -13138, -13120,
			-13107, -13096, -13095, -13091, -13076, -13068, -13063, -13060,
			-12888, -12875, -12871, -12860, -12858, -12852, -12849, -12838,
			-12831, -12829, -12812, -12802, -12607, -12597, -12594, -12585,
			-12556, -12359, -12346, -12320, -12300, -12120, -12099, -12089,
			-12074, -12067, -12058, -12039, -11867, -11861, -11847, -11831,
			-11798, -11781, -11604, -11589, -11536, -11358, -11340, -11339,
			-11324, -11303, -11097, -11077, -11067, -11055, -11052, -11045,
			-11041, -11038, -11024, -11020, -11019, -11018, -11014, -10838,
			-10832, -10815, -10800, -10790, -10780, -10764, -10587, -10544,
			-10533, -10519, -10331, -10329, -10328, -10322, -10315, -10309,
			-10307, -10296, -10281, -10274, -10270, -10262, -10260, -10256,
			-10254 };
	// 存放拼音
	private static final String lc_pinyinValue[] = { "A", "AI", "AN", "ANG",
			"AO", "BA", "BAI", "BAN", "BANG", "BAO", "BEI", "BEN", "BENG",
			"BI", "BIAN", "BIAO", "BIE", "BIN", "BING", "BO", "BU", "CA",
			"CAI", "CAN", "CANG", "CAO", "CE", "CENG", "CHA", "CHAI", "CHAN",
			"CHANG", "CHAO", "CHE", "CHEN", "CHENG", "CHI", "CHONG", "CHOU",
			"CHU", "CHUAI", "CHUAN", "CHUANG", "CHUI", "CHUN", "CHUO", "CI",
			"CONG", "COU", "CU", "CUAN", "CUI", "CUN", "CUO", "DA", "DAI",
			"DAN", "DANG", "DAO", "DE", "DENG", "DI", "DIAN", "DIAO", "DIE",
			"DING", "DIU", "DONG", "DOU", "DU", "DUAN", "DUI", "DUN", "DUO",
			"E", "EN", "ER", "FA", "FAN", "FANG", "FEI", "FEN", "FENG", "FO",
			"FOU", "FU", "GA", "GAI", "GAN", "GANG", "GAO", "GE", "GEI", "GEN",
			"GENG", "GONG", "GOU", "GU", "GUA", "GUAI", "GUAN", "GUANG", "GUI",
			"GUN", "GUO", "HA", "HAI", "HAN", "HANG", "HAO", "HE", "HEI",
			"HEN", "HENG", "HONG", "HOU", "HU", "HUA", "HUAI", "HUAN", "HUANG",
			"HUI", "HUN", "HUO", "JI", "JIA", "JIAN", "JIANG", "JIAO", "JIE",
			"JIN", "JING", "JIONG", "JIU", "JU", "JUAN", "JUE", "JUN", "KA",
			"KAI", "KAN", "KANG", "KAO", "KE", "KEN", "KENG", "KONG", "KOU",
			"KU", "KUA", "KUAI", "KUAN", "KUANG", "KUI", "KUN", "KUO", "LA",
			"LAI", "LAN", "LANG", "LAO", "LE", "LEI", "LENG", "LI", "LIA",
			"LIAN", "LIANG", "LIAO", "LIE", "LIN", "LING", "LIU", "LONG",
			"LOU", "LU", "LUAN", "LUE", "LUN", "LUO", "LV", "MA", "MAI", "MAN",
			"MANG", "MAO", "ME", "MEI", "MEN", "MENG", "MI", "MIAN", "MIAO",
			"MIE", "MIN", "MING", "MIU", "MO", "MOU", "MU", "NA", "NAI", "NAN",
			"NANG", "NAO", "NE", "NEI", "NEN", "NENG", "NI", "NIAN", "NIANG",
			"NIAO", "NIE", "NIN", "NING", "NIU", "NONG", "NU", "NUAN", "NUE",
			"NUO", "NV", "O", "OU", "PA", "PAI", "PAN", "PANG", "PAO", "PEI",
			"PEN", "PENG", "PI", "PIAN", "PIAO", "PIE", "PIN", "PING", "PO",
			"PU", "QI", "QIA", "QIAN", "QIANG", "QIAO", "QIE", "QIN", "QING",
			"QIONG", "QIU", "QU", "QUAN", "QUE", "QUN", "RAN", "RANG", "RAO",
			"RE", "REN", "RENG", "RI", "RONG", "ROU", "RU", "RUAN", "RUI",
			"RUN", "RUO", "SA", "SAI", "SAN", "SANG", "SAO", "SE", "SEN",
			"SENG", "SHA", "SHAI", "SHAN", "SHANG", "SHAO", "SHE", "SHEN",
			"SHENG", "SHI", "SHOU", "SHU", "SHUA", "SHUAI", "SHUAN", "SHUANG",
			"SHUI", "SHUN", "SHUO", "SI", "SONG", "SOU", "SU", "SUAN", "SUI",
			"SUN", "SUO", "TA", "TAI", "TAN", "TANG", "TAO", "TE", "TENG",
			"TI", "TIAN", "TIAO", "TIE", "TING", "TONG", "TOU", "TU", "TUAN",
			"TUI", "TUN", "TUO", "WA", "WAI", "WAN", "WANG", "WEI", "WEN",
			"WENG", "WO", "WU", "XI", "XIA", "XIAN", "XIANG", "XIAO", "XIE",
			"XIN", "XING", "XIONG", "XIU", "XU", "XUAN", "XUE", "XUN", "YA",
			"YAN", "YANG", "YAO", "YE", "YI", "YIN", "YING", "YO", "YONG",
			"YOU", "YU", "YUAN", "YUE", "YUN", "ZA", "ZAI", "ZAN", "ZANG",
			"ZAO", "ZE", "ZEI", "ZEN", "ZENG", "ZHA", "ZHAI", "ZHAN", "ZHANG",
			"ZHAO", "ZHE", "ZHEN", "ZHENG", "ZHI", "ZHONG", "ZHOU", "ZHU",
			"ZHUA", "ZHUAI", "ZHUAN", "ZHUANG", "ZHUI", "ZHUN", "ZHUO", "ZI",
			"ZONG", "ZOU", "ZU", "ZUAN", "ZUI", "ZUN", "ZUO" };
	
	/*
	 * 获取汉字的拼音码
	 */
	public static String hanziToPinYin(String hanzi) {

		String pinyin = "";
		try {
			byte[] gbCode = hanzi.getBytes(gbRule);

			for (int i = 0; i < gbCode.length; i += 2) {
				byte[] tempGbCode = new byte[2];
				tempGbCode[0] = gbCode[i];
				tempGbCode[1] = gbCode[i + 1];
				int hightByte = 256 + tempGbCode[0];
				int lowByte = 256 + tempGbCode[1];

				int ascii = (256 * hightByte + lowByte) - 256 * 256;
				pinyin += getPinyinByAscii(ascii);
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return pinyin;
	}

	/*
	 * 获取汉字拼音码的首字母
	 */
	public static String hanziToFirstPinYin(String hanzi) {
		String pinyin = "";
		try {
			char[] singleGB2312Chars = hanzi.toCharArray();  
			for(int j=0;j<singleGB2312Chars.length;j++){
				byte[] gbCode = String.valueOf(singleGB2312Chars[j]).getBytes(gbRule);
				if(gbCode.length<2){
					pinyin+=singleGB2312Chars[j];
				}else{
				for (int i = 0; i < gbCode.length; i += 2) {
					byte[] tempGbCode = new byte[2];
					tempGbCode[0] = gbCode[i];
					tempGbCode[1] = gbCode[i + 1];
	
					pinyin += queryFirstPinyinByZoneCode(CodeConvertUtil
							.gbCodeToZoneCode(tempGbCode));
				}
				}
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return pinyin;
	}

	/*
	 * 根据单个汉字的ascii码获取汉字的拼音
	 */
	private static String getPinyinByAscii(int ascii) {

		String pinyin = null;

		if (ascii > 0 && ascii < 160) { // 单字符
			return String.valueOf((char) ascii);
		}

		if (ascii < -20319 || ascii > -10247) { // 不知道的字符
			return null;
		}
		for (int i = 0; i < li_pinyinValue.length; i++) {
			if (ascii < li_pinyinValue[i]) {
				pinyin = lc_pinyinValue[i - 1];
				break;
			}
		}

		return pinyin;
	}

	/*
	 * 根据区位码获取拼音码的首字母
	 */
	private static String queryFirstPinyinByZoneCode(String zoneCode) {

		String pinyin = null;
		int zoneCodeInt = Integer.parseInt(zoneCode);
		for (int i = 0; i < li_FirstPinyinValue.length; i++) {
			if (zoneCodeInt < li_FirstPinyinValue[i]) {
				pinyin = String.valueOf(lc_FirstPinyinValue[i - 1]);
				break;
			}
		}
		return pinyin;
	}

}
