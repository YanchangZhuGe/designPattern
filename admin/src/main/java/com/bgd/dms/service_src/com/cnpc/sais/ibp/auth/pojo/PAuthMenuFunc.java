package com.cnpc.sais.ibp.auth.pojo;

@SuppressWarnings("serial")
public class PAuthMenuFunc  implements java.io.Serializable {


    // Fields    

     private String menuFuncId;
     private String menuId;
     private String funcId;


    // Constructors

    /** default constructor */
    public PAuthMenuFunc() {
    }

    
    /** full constructor */
    public PAuthMenuFunc(String menuId, String funcId) {
        this.menuId = menuId;
        this.funcId = funcId;
    }

   
    // Property accessors

    public String getMenuFuncId() {
        return this.menuFuncId;
    }
    
    public void setMenuFuncId(String menuFuncId) {
        this.menuFuncId = menuFuncId;
    }

    public String getMenuId() {
        return this.menuId;
    }
    
    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getFuncId() {
        return this.funcId;
    }
    
    public void setFuncId(String funcId) {
        this.funcId = funcId;
    }
   








}