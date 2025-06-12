/**
 * 
 */
package com.cnpc.sais.ibp.auth.pojo;

/**
 * @author rechete
 *
 */
public class PAuthFilterItem {
    private String entityId;	
    private String filterId;

    private String userId;
    private String filterDateItem;
    private String antiFilterDI;
    private String remark;
    
    public String getAntiFilterDI() {
		return antiFilterDI;
	}
	public void setAntiFilterDI(String antiFilterDI) {
		this.antiFilterDI = antiFilterDI;
	}
	
    
    
    public String getFilterDateItem() {
		return filterDateItem;
	}
	public void setFilterDateItem(String filterDateItem) {
		this.filterDateItem = filterDateItem;
	}
	
    
	public String getEntityId() {
		return entityId;
	}
	public void setEntityId(String entityId) {
		this.entityId = entityId;
	}
	public String getFilterId() {
		return filterId;
	}
	public void setFilterId(String filterId) {
		this.filterId = filterId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}   
    
}
