package com.example.utils.file.enums;
/**
 * <p>Title：</p>
 *
 * <p>Description：是否收取滞纳金</p>
 *
 * <p>Company：北京九恒星科技股份有限公司</p>
 *
 * @author hsw
 * 
 * @since：2018年3月16日 下午7:56:26
 * 
 */
public enum IsGetOverdue {
		NOT_GET(0,"否"),
	 	GET(1,"是");
		private Integer value;
		private String name;

		private IsGetOverdue(Integer value, String name) {
			this.value = value;
			this.name = name;
		}
		public static String getTypeName(Integer value){
			for(IsGetOverdue p :values()){
				if(p.getValue().equals(value)){
					return p.getName();
				}
			}
			return "";
		}
		public Integer getValue() {
			return value;
		}
		public void setValue(Integer value) {
			this.value = value;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
}
