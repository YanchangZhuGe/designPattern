/**
 * 
 */
package com.cnpc.sais.ibp.auth.pojo;

import java.util.Set;

/**
 * @author rechete
 *
 */
public class PAuthFuncFilter {
    private String entityId;	
    private String funcId;

    private String filterColumnName;
    private String filterType;
    private String filterDataItem;
    private String remark;
    
	private Set<PAuthFilterScope> filterScopes; 
    private Set<PAuthFilterItem> filterItems;       
    
    public Set<PAuthFilterScope> getFilterScopes() {
		return filterScopes;
	}
	public void setFilterScopes(Set<PAuthFilterScope> filterScopes) {
		this.filterScopes = filterScopes;
	}
	public Set<PAuthFilterItem> getFilterItems() {
		return filterItems;
	}
	public void setFilterItems(Set<PAuthFilterItem> filterItems) {
		this.filterItems = filterItems;
	}

    
	public String getEntityId() {
		return entityId;
	}
	public void setEntityId(String entityId) {
		this.entityId = entityId;
	}
	public String getFuncId() {
		return funcId;
	}
	public void setFuncId(String funcId) {
		this.funcId = funcId;
	}
	public String getFilterColumnName() {
		return filterColumnName;
	}
	public void setFilterColumnName(String filterColumnName) {
		this.filterColumnName = filterColumnName;
	}
	public String getFilterType() {
		return filterType;
	}
	public void setFilterType(String filterType) {
		this.filterType = filterType;
	}

	public String getFilterDataItem() {
		return filterDataItem;
	}
	public void setFilterDataItem(String filterDataItem) {
		this.filterDataItem = filterDataItem;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
}
