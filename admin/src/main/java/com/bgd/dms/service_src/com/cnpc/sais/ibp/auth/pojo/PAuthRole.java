package com.cnpc.sais.ibp.auth.pojo;

import java.util.Set;


@SuppressWarnings("serial")
public class PAuthRole  implements java.io.Serializable {


    // Fields    

     private String roleId;
     private String roleEName;
     private String roleCName;
     private String dataOrgId;
     private String userOrgId;
     private String dataOrgName;
     
     private Set<PAuthRoleFunc> roleFuncs;



    // Constructors

    /** default constructor */
    public  PAuthRole() {

    }

    
    /** full constructor */
    public PAuthRole(String roleEName, String roleCName, String dataOrgId, String userOrgId) {
        this.roleEName = roleEName;
        this.roleCName = roleCName;
        this.dataOrgId = dataOrgId;
        this.userOrgId = userOrgId;
    }

   
    // Property accessors

    public String getRoleId() {
        return this.roleId;
    }
    
    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getRoleEName() {
        return this.roleEName;
    }
    
    public void setRoleEName(String roleEName) {
        this.roleEName = roleEName;
    }

    public String getRoleCName() {
        return this.roleCName;
    }
    
    public void setRoleCName(String roleCName) {
        this.roleCName = roleCName;
    }

    public String getDataOrgId() {
        return this.dataOrgId;
    }
    
    public void setDataOrgId(String dataOrgId) {
        this.dataOrgId = dataOrgId;
    }

    public String getUserOrgId() {
        return this.userOrgId;
    }
    
    public void setUserOrgId(String userOrgId) {
        this.userOrgId = userOrgId;
    }


	public Set<PAuthRoleFunc> getRoleFuncs() {
		return roleFuncs;
	}


	public void setRoleFuncs(Set<PAuthRoleFunc> roleFuncs) {
		this.roleFuncs = roleFuncs;
	}


	public String getDataOrgName() {
		return dataOrgName;
	}


	public void setDataOrgName(String dataOrgName) {
		this.dataOrgName = dataOrgName;
	}
   








}