package com.cnpc.sais.ibp.auth.pojo;

public class PAuthCsst {

	private String entity_id;
	private String func_id;
	private PAuthFunction func;
	private String hint;
	private String cdt_sql;
	private String remark;

	public String getEntity_id() {
		return entity_id;
	}

	public void setEntity_id(String entity_id) {
		this.entity_id = entity_id;
	}

	public String getFunc_id() {
		return func_id;
	}

	public void setFunc_id(String func_id) {
		this.func_id = func_id;
	}

	public PAuthFunction getFunc() {
		return func;
	}

	public void setFunc(PAuthFunction func) {
		this.func = func;
	}

	public String getHint() {
		return hint;
	}

	public void setHint(String hint) {
		this.hint = hint;
	}

	public String getCdt_sql() {
		return cdt_sql;
	}

	public void setCdt_sql(String cdt_sql) {
		this.cdt_sql = cdt_sql;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}
