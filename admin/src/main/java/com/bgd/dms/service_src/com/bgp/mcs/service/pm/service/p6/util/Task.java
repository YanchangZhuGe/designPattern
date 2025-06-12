package com.bgp.mcs.service.pm.service.p6.util;

import java.sql.Timestamp;

/**
 * Task entity. @author MyEclipse Persistence Tools
 */

public class Task implements java.io.Serializable {

	// Fields

	private Integer id;
	private String taskId;
	private Timestamp startDate;
	private Timestamp endDate;
	private Timestamp plannedStartDate;
	private Timestamp plannedEndDate;
	private Integer percentDone;
	private String name;
	private Integer priority;
	private Timestamp baselineStartDate;
	private Timestamp baselineEndDate;
	private Integer parentId;
	private Double duration;
	private String durationUnit;
	private String otherField;
	
	private String isWbs;
	private String isRoot;
	
	private String checked;
	
	// Constructors

	/** default constructor */
	public Task() {
	}

	/** minimal constructor */
	public Task(Timestamp startDate, Timestamp endDate, Integer percentDone,
			String name, Integer priority) {
		this.startDate = startDate;
		this.endDate = endDate;
		this.percentDone = percentDone;
		this.name = name;
		this.priority = priority;
	}

	/** full constructor */
	public Task(Integer id, Timestamp startDate, Timestamp endDate,
			Timestamp plannedStartDate, Timestamp plannedEndDate,
			Integer percentDone, String name, Integer priority,
			Timestamp baselineStartDate, Timestamp baselineEndDate,
			Integer parentId, Double duration, String durationUnit,
			String otherField, String isWbs, String taskId, String isRoot, String checked) {
		super();
		this.id = id;
		this.taskId = taskId;
		this.startDate = startDate;
		this.endDate = endDate;
		this.plannedStartDate = plannedStartDate;
		this.plannedEndDate = plannedEndDate;
		this.percentDone = percentDone;
		this.name = name;
		this.priority = priority;
		this.baselineStartDate = baselineStartDate;
		this.baselineEndDate = baselineEndDate;
		this.parentId = parentId;
		this.duration = duration;
		this.durationUnit = durationUnit;
		this.otherField = otherField;
		this.isWbs = isWbs;
		this.isRoot = isRoot;
		this.checked = checked;
	}

	// Property accessors

	public String getChecked() {
		return checked;
	}

	public void setChecked(String checked) {
		this.checked = checked;
	}

	public Integer getId() {
		return this.id;
	}


	public void setId(Integer id) {
		this.id = id;
	}

	public Timestamp getStartDate() {
		return this.startDate;
	}

	public void setStartDate(Timestamp startDate) {
		this.startDate = startDate;
	}

	public Timestamp getEndDate() {
		return this.endDate;
	}

	public void setEndDate(Timestamp endDate) {
		this.endDate = endDate;
	}

	public Integer getPercentDone() {
		return this.percentDone;
	}

	public void setPercentDone(Integer percentDone) {
		this.percentDone = percentDone;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getPriority() {
		return this.priority;
	}

	public void setPriority(Integer priority) {
		this.priority = priority;
	}

	public Timestamp getBaselineStartDate() {
		return this.baselineStartDate;
	}

	public void setBaselineStartDate(Timestamp baselineStartDate) {
		this.baselineStartDate = baselineStartDate;
	}

	public Timestamp getBaselineEndDate() {
		return this.baselineEndDate;
	}

	public void setBaselineEndDate(Timestamp baselineEndDate) {
		this.baselineEndDate = baselineEndDate;
	}

	public Integer getParentId() {
		return this.parentId;
	}

	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}

	public Double getDuration() {
		return this.duration;
	}

	public void setDuration(Double duration) {
		this.duration = duration;
	}

	public String getDurationUnit() {
		return this.durationUnit;
	}

	public void setDurationUnit(String durationUnit) {
		this.durationUnit = durationUnit;
	}

	public String getOtherField() {
		return this.otherField;
	}

	public void setOtherField(String otherField) {
		this.otherField = otherField;
	}

	public String getIsWbs() {
		return isWbs;
	}

	public void setIsWbs(String isWbs) {
		this.isWbs = isWbs;
	}

	public Timestamp getPlannedStartDate() {
		return plannedStartDate;
	}

	public void setPlannedStartDate(Timestamp plannedStartDate) {
		this.plannedStartDate = plannedStartDate;
	}

	public Timestamp getPlannedEndDate() {
		return plannedEndDate;
	}

	public void setPlannedEndDate(Timestamp plannedEndDate) {
		this.plannedEndDate = plannedEndDate;
	}

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getIsRoot() {
		return isRoot;
	}

	public void setIsRoot(String isRoot) {
		this.isRoot = isRoot;
	}

}