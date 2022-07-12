package designPattern.behavior.util;


import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

/**
 * NAS 文件上传工具
 */
public class NasUtil {

    public static Map fileUpload(MultipartFile[] files, String uploadPath) {
        // 获取上传文件路径
        Map map = new HashMap<>();
        for (MultipartFile file : files) {
            String fileName = file.getOriginalFilename();
            uploadPath = uploadPath.endsWith("/") == true ? uploadPath : uploadPath + "/";
            String filePath = uploadPath + fileName;
            File savefile = new File(filePath);
            if (!savefile.getParentFile().exists()) {
                savefile.getParentFile().mkdirs();
            }
            try {
                // 获取输入流
                InputStream inputStream = file.getInputStream();
                // 文件加密
                FileDES td = FileDES.getInstance();
                td.encrypt2(inputStream, filePath);
                // file.transferTo(savefile);
            } catch (IllegalStateException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }

            map.put(fileName, filePath);
        }
        return map;
    }

    public static Map fileUpload(String fileName, byte[] file, String uploadPath) {
        // 获取上传文件路径
        Map map = new HashMap<>();
        uploadPath = uploadPath.endsWith("/") == true ? uploadPath : uploadPath + "/";
        String filePath = uploadPath + fileName;
        File savefile = new File(filePath);
        if (!savefile.getParentFile().exists()) {
            savefile.getParentFile().mkdirs();
        }
        try {
            // 获取输入流
            InputStream inputStream = new ByteArrayInputStream(file);
            // 文件加密
            FileDES td = FileDES.getInstance();
            td.encrypt2(inputStream, filePath);
            // file.transferTo(savefile);
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        map.put(fileName, filePath);
        return map;
    }

    public static void download(String name, HttpServletResponse response, String basePath) throws Exception {
        String filePath = basePath.endsWith("/") == true ? basePath : basePath + File.separator;
        File file = new File(filePath + name);
        response.setContentType("application/octet-stream; charset=utf-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(name, "UTF-8"));
        byte[] buffer = new byte[1024];
        BufferedInputStream bis = null;
        try {
            FileInputStream fis = new FileInputStream(file);
            bis = new BufferedInputStream(fis);

            OutputStream os = response.getOutputStream();
            // 获取文件加密解密对象
            FileDES td = FileDES.getInstance();
            // 文件解密
            td.decrypt2(bis, os);
        } finally {
            if (bis != null) {
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}


