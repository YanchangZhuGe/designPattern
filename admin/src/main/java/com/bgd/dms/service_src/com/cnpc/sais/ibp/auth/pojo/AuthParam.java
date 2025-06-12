/**
 * 权限使用到的参数
 */
package com.cnpc.sais.ibp.auth.pojo;

/**
 * @author rechete
 * Revision History:
 * 4.2 add prjTable
 *     add creatorColumn
 */
public class  AuthParam{
	private String orgTable = "P_AUTH_ORG";
	private String orgIdColumn = "ORG_ID";
	private String orgCodeColumn = "ORG_CODE";
	private String prjTable = "P_AUTH_PROJECT";
	private String prjIdColumn = "ENTITY_ID";
	private String creatorColumn = "CREATOR";
	private String defaultPassword ="Passcode@2129";
	
	public String getPrjTable() {
		return prjTable;
	}
	public void setPrjTable(String prjTable) {
		this.prjTable = prjTable;
	}
	public String getPrjIdColumn() {
		return prjIdColumn;
	}
	public void setPrjIdColumn(String prjIdColumn) {
		this.prjIdColumn = prjIdColumn;
	}
	
	
	public String getOrgTable() {
		return orgTable;
	}
	public void setOrgTable(String orgTable) {
		this.orgTable = orgTable;
	}
	public String getOrgIdColumn() {
		return orgIdColumn;
	}
	public void setOrgIdColumn(String orgIdColumn) {
		this.orgIdColumn = orgIdColumn;
	}
	public String getOrgCodeColumn() {
		return orgCodeColumn;
	}
	public void setOrgCodeColumn(String orgCodeColumn) {
		this.orgCodeColumn = orgCodeColumn;
	}
	public String getDefaultPassword() {
		return defaultPassword;
	}
	public void setDefaultPassword(String defaultPassword) {
		this.defaultPassword = defaultPassword;
	}
	public String getCreatorColumn() {
		return creatorColumn;
	}
	public void setCreatorColumn(String creatorColumn) {
		this.creatorColumn = creatorColumn;
	}
	
	
}
