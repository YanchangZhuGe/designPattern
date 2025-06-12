package com.cnpc.sais.ibp.auth.pojo;

@SuppressWarnings("serial")
public class PAuthFunction  implements java.io.Serializable {


    // Fields    

     private String funcId;
     private String funcCode;
     private String funcEName;
     private String funcCName;
     private String funcType;
     private String funcGroupId;


    // Constructors

    /** default constructor */
    public PAuthFunction() {
    }

    
    /** full constructor */
    public PAuthFunction(String funcCode, String funcEName, String funcCName, String funcType, String funcGroupId) {
        this.funcCode = funcCode;
        this.funcEName = funcEName;
        this.funcCName = funcCName;
        this.funcType = funcType;
        this.funcGroupId = funcGroupId;
    }

   
    // Property accessors

    public String getFuncId() {
        return this.funcId;
    }
    
    public void setFuncId(String funcId) {
        this.funcId = funcId;
    }

    public String getFuncCode() {
        return this.funcCode;
    }
    
    public void setFuncCode(String funcCode) {
        this.funcCode = funcCode;
    }

    public String getFuncEName() {
        return this.funcEName;
    }
    
    public void setFuncEName(String funcEName) {
        this.funcEName = funcEName;
    }

    public String getFuncCName() {
        return this.funcCName;
    }
    
    public void setFuncCName(String funcCName) {
        this.funcCName = funcCName;
    }

    public String getFuncType() {
        return this.funcType;
    }
    
    public void setFuncType(String funcType) {
        this.funcType = funcType;
    }

    public String getFuncGroupId() {
        return this.funcGroupId;
    }
    
    public void setFuncGroupId(String funcGroupId) {
        this.funcGroupId = funcGroupId;
    }
   








}