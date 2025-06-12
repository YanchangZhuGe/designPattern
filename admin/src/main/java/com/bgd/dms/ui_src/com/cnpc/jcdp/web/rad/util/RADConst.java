/**
 * 
 */
package com.cnpc.jcdp.web.rad.util;

/**
 * @author rechete
 *
 */
public class RADConst {
	public static String WEB_ROOT = "";
	
	public static int DEFAULT_MEMO_ROWS = 2;
	public static int DEFAULT_MEMO_COLS = 40;
	public static int POP_WINDOW_HEIGHT = 400;
	
	/**
	 * 列表查询页面打开子页面的方式：弹出窗口，本页跳转
	 */	
	public enum PAGER_OPEN_TYPE{
		POP,LINK;
	}
	
	/**
	 * 列表查询页面的查询条件样式:表单，下拉框
	 */
	public enum QUERY_CDT_TYPE{
		FORM,SELECT;
	}	
	
	/**
	 * 记录选择类型:单项选择radiobutton，多项选择checkbox
	 */
	public enum RECORD_SEL_TYPE{
		RadioButton,Checkbox;
	}	
	
	//列表类型:普通列表，关系选择列表，外键选择列表，主子表1的子表列表
	public enum LISTTYPE  {List2View,List2Sel,List2Link,List2Compose};
	

	
	public interface TitleType{
		public final int TAB = 0;//标签类
		public final int Hint = 1;//提示类
		public final int SUB_Hint = 2;//明细类
	}
	
	public interface PMDAction{
		//对单表的的CRU
		public final String S_C = "S_C";
		public final String S_U = "S_U";
		public final String S_R = "S_R";
		//主子表在同一页面的CRU
		public final String C_C = "C_C";
		public final String C_U = "C_U";
		public final String C_R = "C_R";	
		//主子表1
		public final String M_S = "M_S";
		//多选页面
		public final String L2S = "L2S";
		//单选页面for外键关联
		public final String L2L = "L2L";
	}	
}
