package com.cnpc.sais.ibp.auth.pojo;

@SuppressWarnings("serial")
public class PAuthRoleFunc  implements java.io.Serializable {


    // Fields    

     private String roleFuncId;
     private String roleId;
     private String funcId;


    // Constructors

    /** default constructor */
    public PAuthRoleFunc() {
    }

    
    /** full constructor */
    public PAuthRoleFunc(String roleId, String funcId) {
        this.roleId = roleId;
        this.funcId = funcId;
    }

   
    // Property accessors

    public String getRoleFuncId() {
        return this.roleFuncId;
    }
    
    public void setRoleFuncId(String roleFuncId) {
        this.roleFuncId = roleFuncId;
    }

    public String getRoleId() {
        return this.roleId;
    }
    
    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getFuncId() {
        return this.funcId;
    }
    
    public void setFuncId(String funcId) {
        this.funcId = funcId;
    }
   








}