package com.cnpc.jcdp.webapp.upload;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;

public class FilesUploadServlet extends HttpServlet {
	
	private static ILog log = LogFactory.getLogger(FilesUploadServlet.class);

	/**
	 * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	 */

	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);

	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String path = WebPathUtil.getWebProjectPath();
		 UserToken userToken = OMSMVCUtil.getUserToken(req);
		// 输出文件路径
		String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + userToken.getEmpId();
		
		File filePath = new File(outFilePath);

		if (!filePath.exists()) {
			filePath.mkdirs();
		}
		DiskFileItemFactory fac = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(fac);
		upload.setHeaderEncoding("utf-8");
		
		List fileList = null;
		try {
			fileList = upload.parseRequest(req);
		} catch (FileUploadException ex) {
			return;
		}
		Iterator<FileItem> it = fileList.iterator();
		String name = "";
		String extName = "";
		while (it.hasNext()) {
			FileItem item = it.next();
			if (!item.isFormField()) {
				name = item.getName();
				log.info("******************* name:"+name);
				long size = item.getSize();
				log.info("$$$$$$$$$$$$$$$$$$$ size:"+size);
				if (name == null || name.trim().equals("")) {
					continue;
				}
//				// 扩展名格式：
//				if (name.lastIndexOf(".") >= 0) {
//					extName = name.substring(name.lastIndexOf("."));
//				}
				File file = null;
				do {
					// 生成文件名：
//					name = UUID.randomUUID().toString();
					file = new File(filePath + name );
				} while (file.exists());
				File saveFile = new File(filePath +File.separator+ name );
				try {
					item.write(saveFile);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		resp.getWriter().print(name );
		
//		resp.getWriter().write("1"); 
	}

}
