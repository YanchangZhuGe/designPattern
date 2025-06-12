package com.cnpc.sais.ibp.auth.pojo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@SuppressWarnings("serial")
public class PAuthUser  implements java.io.Serializable {


   
	 /**
	  * pk,32bit
	  */
     private String userId;
     
     private String orgId;
     private String userPwd;
     private String userName;
     private String loginId;
     private String userStatus;
     private String email;
     private String loginIp;
     private Date lastLoginTime;
     private Date thisLoginTime;
     private String domain;
     private String empId;
     
     public String getEmpId() {
		return empId;
	}

	public void setEmpId(String empId) {
		this.empId = empId;
	}

	public String getDomain() {
		return domain;
	}

	public void setDomain(String domain) {
		this.domain = domain;
	}

	//other properties
     private List<PAuthRole> roles = new ArrayList<PAuthRole>();
     private PAuthOrg org;

     public PAuthOrg getOrg() {
		return org;
	}

	public void setOrg(PAuthOrg org) {
		this.org = org;
	}

	public void addRole(PAuthRole role){
    	 roles.add(role);
     }
	
	public List<PAuthRole> getRoles(){
		return roles;
	}

    // Constructors

    /** default constructor */
    public PAuthUser() {
    }

    
    /** full constructor */
    public PAuthUser(String orgId, String userPwd, String userName, String loginId, String userStatus) {
        this.orgId = orgId;
        this.userPwd = userPwd;
        this.userName = userName;
        this.loginId = loginId;
        this.userStatus = userStatus;
    }

   
    // Property accessors

    public String getUserId() {
        return this.userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getOrgId() {
        return this.orgId;
    }
    
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getUserPwd() {
        return this.userPwd;
    }
    
    public void setUserPwd(String userPwd) {
        this.userPwd = userPwd;
    }

    public String getUserName() {
        return this.userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getLoginId() {
        return this.loginId;
    }
    
    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getUserStatus() {
        return this.userStatus;
    }
    
    public void setUserStatus(String userStatus) {
        this.userStatus = userStatus;
    }

	public void setRoles(List<PAuthRole> roles) {
		this.roles = roles;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getLastLoginTime() {
		return lastLoginTime;
	}

	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}

	public String getLoginIp() {
		return loginIp;
	}

	public void setLoginIp(String loginIp) {
		this.loginIp = loginIp;
	}

	public Date getThisLoginTime() {
		return thisLoginTime;
	}

	public void setThisLoginTime(Date thisLoginTime) {
		this.thisLoginTime = thisLoginTime;
	}
   








}