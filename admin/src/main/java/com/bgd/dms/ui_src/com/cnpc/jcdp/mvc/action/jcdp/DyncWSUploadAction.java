package com.cnpc.jcdp.mvc.action.jcdp;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.bgp.dms.service.scrape.GmsDevice;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.mvc.upload.FormFile;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.webapp.constant.MVCConstant;


public class DyncWSUploadAction extends WSAction{
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
	@Override
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		PrintWriter out = null;
		try {
			JSONObject returnObject = new JSONObject();
			if(msg==null){
				log.error("异步附件处理错误,msg is null");
				returnObject.put("returnCode", 1);
				returnObject.put("returnMsg", "相应数据为空");
			}else if(!msg.isSuccessRet()){
				log.error("异步附件处理错误,msg retCode is ["+msg.getRetCode()+"]");
				returnObject.put("returnCode", 2);
				returnObject.put("returnMsg", "操作失败!");
			}else{
				returnObject.put("returnCode", 0);
				returnObject.put("returnMsg", "操作成功!");
				List<MsgElement> msgs = msg.getMsgElements("nodes");
				List<GmsDevice> nodes = new ArrayList<GmsDevice>();
				if (msgs != null && msgs.size() > 0)
					for (int i = 0; i < msgs.size(); i++) {
						GmsDevice node = (GmsDevice) msgs.get(i).toPojo(
								GmsDevice.class);
						nodes.add(node);
					}
				returnObject.put("nodes", nodes);
				String flag_asset = msg.getValue("flag_asset");//执行是否成功
				returnObject.put("flag_asset", flag_asset);
				String flag_damage = msg.getValue("flag_damage");//执行是否成功
				returnObject.put("flag_damage", flag_damage);
				returnObject.put("time_asset", msg.getValue("time_asset"));
				returnObject.put("time_damage", msg.getValue("time_damage"));
				returnObject.put("count_success", msg.getValue("count_success"));
				returnObject.put("count_error", msg.getValue("count_error"));
			}
			out = response.getWriter();
			out.print(returnObject.toString());
			out.flush();
		} catch (Exception e) {
			out.print("no");
			e.printStackTrace();
		} finally {

			out.close();
		}

		return null;
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
