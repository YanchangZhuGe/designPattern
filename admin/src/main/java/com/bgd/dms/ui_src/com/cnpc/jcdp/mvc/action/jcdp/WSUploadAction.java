package com.cnpc.jcdp.mvc.action.jcdp;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.constant.JcdpConstants;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.mvc.upload.FormFile;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.util.EDcode;


public class WSUploadAction extends WSAction{
    public ISrvMsg createDTO(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
    	ServiceCallConfig defaultCall = mapping.getDefaultServiceCallConfig();
    	if( defaultCall == null)
    		return null;
    	return new MQMsgImpl(defaultCall.getOperationName());
    	//return SrvMsgUtil.createISrvMsg(defaultCall.getOperationName());
    }
    
	public void setDTOValue(
            ISrvMsg requestDTO ,
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {    	
        super.setDTOValue(requestDTO, mapping, form, request, response);
        setUploadFileToDTO( requestDTO, mapping, form, request, response );
    }
	
    public final void setUploadFileToDTO(
    		ISrvMsg requestDTO ,
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
    	Hashtable files = form.getMultipartRequestHandler().getFileElements(); 
    	if(files.size()<=0) return;
    	
    	List<WSFile> omsFiles = new ArrayList();    	
		for (Enumeration e = files.keys(); e.hasMoreElements(); ) { 
			String key = (String) e.nextElement(); 
			if( key != null && files.get(key) != null){
				FormFile file_ = (FormFile)files.get(key);
				if(file_.getFileName()==null || file_.getFileName().trim().equals("")) continue;
				WSFile omsFile_ = new WSFile();
				omsFile_.setFilename( file_.getFileName());
				omsFile_.setType(getFileType(omsFile_.getFilename()));
				omsFile_.setFileData(file_.getFileData());
				//omsFile_.setContent(EDcode.encode(file_.getFileData()));				
				omsFile_.setKey( key);
				omsFile_.setFilesize( file_.getFileSize()+"");
				omsFiles.add(omsFile_);
			}
		}    	
		MQMsgImpl mqMsg = (MQMsgImpl)requestDTO;
		mqMsg.setFiles(omsFiles);
    	//requestDTO.setValue(JcdpConstants.UPLOAD_FILES_KEY,omsFiles);
    }	
    
    /**
     * 根据文件扩展名判断图象或文档类型
     * A 文档 B 图像
     * @param filename
     * @return
     */
    private String getFileType(String filename){
    	String[] exts = {".jpg",".jpeg",".gif",".bmp"};
    	filename = filename.toLowerCase();
    	for(int i=0;i<exts.length;i++){
    		if(filename.endsWith(exts[i])) return "B";
    	}
    	return "A";
    }
}
