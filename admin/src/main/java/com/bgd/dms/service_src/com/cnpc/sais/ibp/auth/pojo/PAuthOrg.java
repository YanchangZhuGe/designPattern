package com.cnpc.sais.ibp.auth.pojo;

@SuppressWarnings("serial")
public class PAuthOrg implements java.io.Serializable {

	private String orgId;

	private String orgName;

	private String orgDesc;

	private String parentId;

	private String orgCode;

	private String email;

	private String officePhone;

	private String isLeaf;

	private String orderNum;

	public PAuthOrg() {
	}

	public PAuthOrg(String parentId) {
		this.parentId = parentId;
	}

	public PAuthOrg(String orgName, String orgDesc, String parentId,
			String orgCode, String email, String officePhone, String isLeaf,
			String orderNum) {
		this.orgName = orgName;
		this.orgDesc = orgDesc;
		this.parentId = parentId;
		this.orgCode = orgCode;
		this.email = email;
		this.officePhone = officePhone;
		this.isLeaf = isLeaf;
		this.orderNum = orderNum;
	}

	public String getOrgId() {
		return this.orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getOrgName() {
		return this.orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getOrgDesc() {
		return this.orgDesc;
	}

	public void setOrgDesc(String orgDesc) {
		this.orgDesc = orgDesc;
	}

	public String getParentId() {
		return this.parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getOrgCode() {
		return this.orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getOfficePhone() {
		return this.officePhone;
	}

	public void setOfficePhone(String officePhone) {
		this.officePhone = officePhone;
	}

	public String getIsLeaf() {
		return this.isLeaf;
	}

	public void setIsLeaf(String isLeaf) {
		this.isLeaf = isLeaf;
	}

	public String getOrderNum() {
		return this.orderNum;
	}

	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}

}