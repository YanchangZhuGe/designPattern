package com.bgp.gms.service.rm.em.pojo;

public class BgpCommDeviceApplyDetail {

	private String detailId;
	private String applyInfoId;

	private String creator;
	private String createDate;
	private String updator;
	private String modifyDate;
	private String baflag;
	private String notes;
	private String spare1;
	private String spare2;
	private String spare3;
	private String spare4;
	private String spare5;

	private String deviceType;
	private String deviceName;
	private String deviceSpecification;
	private String deviceUnit;
	private String requestQuantity;
	private String auditQuantity;
	private String estimateStartTime;
	private String estimateReturnTime;
	private String estimateUsageDays;
	
	private String procInstId;
	private String procId;
	private String procStatus;
	
	private String applyDetailId;
	private String applyInfoNo;
	private String codingName;

	private String warehouseAmountCount;
	private String warehouseAmount;
	private String warehousStatus;
	private String equpmentFailure;
	private String isAccepted;
	private String receivedDate;
	private String dispatchGroup;
	
	private String warehouseDetailId;
	private String serialNumber;
	
	
	private String dispatchQuantity;
	
	private String transDetailId;
	
	private String licensePlate;
	
	private String deviceAccountId;
	
	private String accountSpare2;
	
	private String whDetailId;
	
	private String detectorId;
	
	private String detectorType;
	private String assembledType;
	private String detectorUnit;
	private String operationType;
	
	private String applyDetailRId;
	private String deviceCapability;
	private String devicePurpose;
	
	private String detAppDetailId;
	
	
	private String location;
	
	private String returnDetailId;
	private String returnRemark;
	private String deviceStatus;
	
	private String returnOrgId;
	private String returnOrgName;
	private String returnSubjectionOrgId;
	private String redispDetailId;
	
	private String techStatus;
	private String deviceLocation;
	private String reWarehouseDetailId;
	
	
	public String getReWarehouseDetailId() {
		return nullToEmpty(reWarehouseDetailId);
	}

	public void setReWarehouseDetailId(String reWarehouseDetailId) {
		this.reWarehouseDetailId = reWarehouseDetailId;
	}

	public String getTechStatus() {
		return nullToEmpty(techStatus);
	}

	public void setTechStatus(String techStatus) {
		this.techStatus = techStatus;
	}

	public String getDeviceLocation() {
		return nullToEmpty(deviceLocation);
	}

	public void setDeviceLocation(String deviceLocation) {
		this.deviceLocation = deviceLocation;
	}

	public String getRedispDetailId() {
		return nullToEmpty(redispDetailId);
	}

	public void setRedispDetailId(String redispDetailId) {
		this.redispDetailId = redispDetailId;
	}

	public String getReturnOrgId() {
		return nullToEmpty(returnOrgId);
	}

	public void setReturnOrgId(String returnOrgId) {
		this.returnOrgId = returnOrgId;
	}

	public String getReturnOrgName() {
		return nullToEmpty(returnOrgName);
	}

	public void setReturnOrgName(String returnOrgName) {
		this.returnOrgName = returnOrgName;
	}

	public String getReturnSubjectionOrgId() {
		return nullToEmpty(returnSubjectionOrgId);
	}

	public void setReturnSubjectionOrgId(String returnSubjectionOrgId) {
		this.returnSubjectionOrgId = returnSubjectionOrgId;
	}

	public String getDeviceStatus() {
		return nullToEmpty(deviceStatus);
	}

	public void setDeviceStatus(String deviceStatus) {
		this.deviceStatus = deviceStatus;
	}

	public String getReturnDetailId() {
		return nullToEmpty(returnDetailId);
	}

	public void setReturnDetailId(String returnDetailId) {
		this.returnDetailId = returnDetailId;
	}

	public String getReturnRemark() {
		return nullToEmpty(returnRemark);
	}

	public void setReturnRemark(String returnRemark) {
		this.returnRemark = returnRemark;
	}

	public String getLocation() {
		return nullToEmpty(location);
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getDetAppDetailId() {
		return nullToEmpty(detAppDetailId);
	}

	public void setDetAppDetailId(String detAppDetailId) {
		this.detAppDetailId = detAppDetailId;
	}

	public String getApplyDetailRId() {
		return nullToEmpty(applyDetailRId);
	}

	public void setApplyDetailRId(String applyDetailRId) {
		this.applyDetailRId = applyDetailRId;
	}

	public String getDeviceCapability() {
		return nullToEmpty(deviceCapability);
	}

	public void setDeviceCapability(String deviceCapability) {
		this.deviceCapability = deviceCapability;
	}

	public String getDevicePurpose() {
		return nullToEmpty(devicePurpose);
	}

	public void setDevicePurpose(String devicePurpose) {
		this.devicePurpose = devicePurpose;
	}

	public String getOperationType() {
		return nullToEmpty(operationType);
	}

	public void setOperationType(String operationType) {
		this.operationType = operationType;
	}

	public String getDetectorUnit() {
		return nullToEmpty(detectorUnit);
	}

	public void setDetectorUnit(String detectorUnit) {
		this.detectorUnit = detectorUnit;
	}

	public String getDetectorType() {
		return nullToEmpty(detectorType);
	}

	public void setDetectorType(String detectorType) {
		this.detectorType = detectorType;
	}

	public String getAssembledType() {
		return nullToEmpty(assembledType);
	}

	public void setAssembledType(String assembledType) {
		this.assembledType = assembledType;
	}

	public String getWhDetailId() {
		return nullToEmpty(whDetailId);
	}

	public void setWhDetailId(String whDetailId) {
		this.whDetailId = whDetailId;
	}

	public String getDetectorId() {
		return nullToEmpty(detectorId);
	}

	public void setDetectorId(String detectorId) {
		this.detectorId = detectorId;
	}

	public String getAccountSpare2() {
		return nullToEmpty(accountSpare2);
	}

	public void setAccountSpare2(String accountSpare2) {
		this.accountSpare2 = accountSpare2;
	}

	public String getDeviceAccountId() {
		return nullToEmpty(deviceAccountId);
	}

	public void setDeviceAccountId(String deviceAccountId) {
		this.deviceAccountId = deviceAccountId;
	}

	public String getLicensePlate() {
		return nullToEmpty(licensePlate);
	}

	public void setLicensePlate(String licensePlate) {
		this.licensePlate = licensePlate;
	}

	public String getTransDetailId() {
		return nullToEmpty(transDetailId);
	}

	public void setTransDetailId(String transDetailId) {
		this.transDetailId = transDetailId;
	}

	public String getSerialNumber() {
		return  nullToEmpty(serialNumber);
	}

	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

	public String getWarehouseDetailId() {
		return nullToEmpty(warehouseDetailId);
	}

	public void setWarehouseDetailId(String warehouseDetailId) {
		this.warehouseDetailId = warehouseDetailId;
	}

	public String getDispatchQuantity() {
		return nullToEmpty(dispatchQuantity);
	}

	public void setDispatchQuantity(String dispatchQuantity) {
		this.dispatchQuantity = dispatchQuantity;
	}

	public String getWarehouseAmountCount() {
		return nullToEmpty(warehouseAmountCount);
	}

	public void setWarehouseAmountCount(String warehouseAmountCount) {
		this.warehouseAmountCount = warehouseAmountCount;
	}

	public String getWarehouseAmount() {
		return nullToEmpty(warehouseAmount);
	}

	public void setWarehouseAmount(String warehouseAmount) {
		this.warehouseAmount = warehouseAmount;
	}

	public String getWarehousStatus() {
		return nullToEmpty(warehousStatus);
	}

	public void setWarehousStatus(String warehousStatus) {
		this.warehousStatus = warehousStatus;
	}

	public String getEqupmentFailure() {
		return nullToEmpty(equpmentFailure);
	}

	public void setEqupmentFailure(String equpmentFailure) {
		this.equpmentFailure = equpmentFailure;
	}

	public String getIsAccepted() {
		return nullToEmpty(isAccepted);
	}

	public void setIsAccepted(String isAccepted) {
		this.isAccepted = isAccepted;
	}

	public String getReceivedDate() {
		return nullToEmpty(receivedDate);
	}

	public void setReceivedDate(String receivedDate) {
		this.receivedDate = receivedDate;
	}

	public String getDispatchGroup() {
		return nullToEmpty(dispatchGroup);
	}

	public void setDispatchGroup(String dispatchGroup) {
		this.dispatchGroup = dispatchGroup;
	}

	public String getProcInstId() {
		return nullToEmpty(procInstId);
	}

	public void setProcInstId(String procInstId) {
		this.procInstId = procInstId;
	}

	public String getProcId() {
		return nullToEmpty(procId);
	}

	public void setProcId(String procId) {
		this.procId = procId;
	}

	public String getProcStatus() {
		return nullToEmpty(procStatus);
	}

	public void setProcStatus(String procStatus) {
		this.procStatus = procStatus;
	}

	public String getApplyDetailId() {
		return nullToEmpty(applyDetailId);
	}

	public void setApplyDetailId(String applyDetailId) {
		this.applyDetailId = applyDetailId;
	}

	public String getApplyInfoNo() {
		return nullToEmpty(applyInfoNo);
	}

	public void setApplyInfoNo(String applyInfoNo) {
		this.applyInfoNo = applyInfoNo;
	}

	public String getCodingName() {
		return nullToEmpty(codingName);
	}

	public void setCodingName(String codingName) {
		this.codingName = codingName;
	}

	private String nullToEmpty(String s){
		return s==null?"":s;
	}
	
	public String getDetailId() {
		return nullToEmpty(detailId);
	}

	public void setDetailId(String detailId) {
		this.detailId = detailId;
	}

	public String getApplyInfoId() {
		return nullToEmpty(applyInfoId);
	}

	public void setApplyInfoId(String applyInfoId) {
		this.applyInfoId = applyInfoId;
	}

	public String getCreator() {
		return nullToEmpty(creator);
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getCreateDate() {
		return nullToEmpty(createDate);
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getUpdator() {
		return nullToEmpty(updator);
	}

	public void setUpdator(String updator) {
		this.updator = updator;
	}

	public String getModifyDate() {
		return nullToEmpty(modifyDate);
	}

	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}

	public String getBaflag() {
		return nullToEmpty(baflag);
	}

	public void setBaflag(String baflag) {
		this.baflag = baflag;
	}

	public String getNotes() {
		return nullToEmpty(notes);
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public String getSpare1() {
		return nullToEmpty(spare1);
	}

	public void setSpare1(String spare1) {
		this.spare1 = spare1;
	}

	public String getSpare2() {
		return nullToEmpty(spare2);
	}

	public void setSpare2(String spare2) {
		this.spare2 = spare2;
	}

	public String getSpare3() {
		return nullToEmpty(spare3);
	}

	public void setSpare3(String spare3) {
		this.spare3 = spare3;
	}

	public String getSpare4() {
		return nullToEmpty(spare4);
	}

	public void setSpare4(String spare4) {
		this.spare4 = spare4;
	}

	public String getSpare5() {
		return nullToEmpty(spare5);
	}

	public void setSpare5(String spare5) {
		this.spare5 = spare5;
	}

	public String getDeviceType() {
		return nullToEmpty(deviceType);
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	public String getDeviceName() {
		return nullToEmpty(deviceName);
	}

	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}

	public String getDeviceSpecification() {
		return nullToEmpty(deviceSpecification);
	}

	public void setDeviceSpecification(String deviceSpecification) {
		this.deviceSpecification = deviceSpecification;
	}

	public String getDeviceUnit() {
		return nullToEmpty(deviceUnit);
	}

	public void setDeviceUnit(String deviceUnit) {
		this.deviceUnit = deviceUnit;
	}

	public String getRequestQuantity() {
		return nullToEmpty(requestQuantity);
	}

	public void setRequestQuantity(String requestQuantity) {
		this.requestQuantity = requestQuantity;
	}

	public String getAuditQuantity() {
		return nullToEmpty(auditQuantity);
	}

	public void setAuditQuantity(String auditQuantity) {
		this.auditQuantity = auditQuantity;
	}

	public String getEstimateStartTime() {
		return nullToEmpty(estimateStartTime);
	}

	public void setEstimateStartTime(String estimateStartTime) {
		this.estimateStartTime = estimateStartTime;
	}

	public String getEstimateReturnTime() {
		return nullToEmpty(estimateReturnTime);
	}

	public void setEstimateReturnTime(String estimateReturnTime) {
		this.estimateReturnTime = estimateReturnTime;
	}

	public String getEstimateUsageDays() {
		return nullToEmpty(estimateUsageDays);
	}

	public void setEstimateUsageDays(String estimateUsageDays) {
		this.estimateUsageDays = estimateUsageDays;
	}

	@Override
	public String toString() {
		return "BgpCommDeviceApplyDetail [applyDetailId=" + detailId
				+ ", applyInfoId=" + applyInfoId + ", creator=" + creator
				+ ", createDate=" + createDate + ", updator=" + updator
				+ ", modifyDate=" + modifyDate + ", baflag=" + baflag
				+ ", notes=" + notes + ", spare1=" + spare1 + ", spare2="
				+ spare2 + ", spare3=" + spare3 + ", spare4=" + spare4
				+ ", spare5=" + spare5 + ", deviceType=" + deviceType
				+ ", deviceName=" + deviceName + ", deviceSpecification="
				+ deviceSpecification + ", deviceUnit=" + deviceUnit
				+ ", requestQuantity=" + requestQuantity + ", auditQuantity="
				+ auditQuantity + ", estimateStartTime=" + estimateStartTime
				+ ", estimateReturnTime=" + estimateReturnTime
				+ ", estimateUsageDays=" + estimateUsageDays + "]";
	}

}
