package designPattern.behavior.util;

import com.nstc.common.entity.core.exception.NsBizException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.net.ftp.*;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.SocketException;
import java.net.URLEncoder;
import java.rmi.RemoteException;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Component
public class FtpUtil {


    private static FTPClient getFtpClient(String host, int port, String account, String pwd)
            throws SocketException, IOException {
        FTPClient ftpClient = new FTPClient();
        ftpClient.setControlEncoding("utf-8");
        // 进入被动模式 （要在连接之前设置）
        ftpClient.enterLocalPassiveMode();
        // 连接到ftp
        ftpClient.connect(host, port);

        if (FTPReply.isPositiveCompletion(ftpClient.getReplyCode())) {
            ftpClient.login(account, pwd);
            if (FTPReply.isPositiveCompletion(ftpClient.getReplyCode())) {
                //log.error(ftpClient.getSystemType());
                FTPClientConfig config = new FTPClientConfig(ftpClient.getSystemType().split(" ")[0]);
                config.setServerLanguageCode("zh");
                ftpClient.configure(config);
                return ftpClient;
            }
        }
        disConnection(ftpClient);
        return null;
    }

    /**
     * 断开连接
     */
    private static void disConnection(FTPClient ftpClient) {
        if (ftpClient.isConnected()) {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    /**
     * ftp 上传
     */
    public static Map ftpUploadFile(MultipartFile[] uploadFile, String basePath, String ftpUrl, Integer ftpPort, String ftpUsername, String ftpPassword) {
        Map map = new HashMap<>();
        try {
            FTPClient client = getFtpClient(ftpUrl, ftpPort, ftpUsername, ftpPassword);
            if (client == null) {
                throw new NsBizException("FTP连接失败");
            }
            client.setFileType(FTP.BINARY_FILE_TYPE);
            //切换到上传目录  ,basepath需已存在
            if (!client.changeWorkingDirectory(basePath)) {
                //如果目录不存在创建目录

                if (!client.makeDirectory(basePath)) {
                    createDirectory(basePath, client);
                } else {
                    client.changeWorkingDirectory(basePath);
                }
            }

            if (uploadFile != null && uploadFile.length > 0) {
                for (int i = 0; i < uploadFile.length; i++) {
                    MultipartFile file = uploadFile[i];
                    String filename = file.getOriginalFilename();
                    saveFile(file, client);

                    basePath = basePath.endsWith("/") == true ? basePath : basePath + "/";
                    map.put(filename, basePath + filename);

                }
            }
            logout(client);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("上传附件失败", e);
        }
        return map;
    }

    /**
     * ftp 上传
     */
    public static Map ftpUploadFile(String fileName, byte[] uploadFile, String basePath, String ftpUrl, Integer ftpPort, String ftpUsername, String ftpPassword) {
        Map map = new HashMap<>();
        try {
            FTPClient client = getFtpClient(ftpUrl, ftpPort, ftpUsername, ftpPassword);
            if (client == null) {
                throw new NsBizException("FTP连接失败");
            }
            client.setFileType(FTP.BINARY_FILE_TYPE);
            //切换到上传目录  ,basepath需已存在
            if (!client.changeWorkingDirectory(basePath)) {
                //如果目录不存在创建目录

                if (!client.makeDirectory(basePath)) {
                    createDirectory(basePath, client);
                } else {
                    client.changeWorkingDirectory(basePath);
                }


            }

            saveFile(fileName, uploadFile, client);

            basePath = basePath.endsWith("/") == true ? basePath : basePath + "/";
            map.put(fileName, basePath + fileName);
            logout(client);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("上传附件失败", e);
        }
        return map;
    }

    private static boolean saveFile(MultipartFile file, FTPClient client) {
        boolean success = false;
        InputStream inStream = null;
        try {
            String fileName = new String(file.getOriginalFilename());
            inStream = file.getInputStream();
            // 对流加密
            FileDES td = FileDES.getInstance();
            inStream = td.encrypt2(inStream);
            success = client.storeFile(fileName, inStream);
            if (success == true) {
                return success;
            }
        } catch (Exception e) {
        } finally {
            if (inStream != null) {
                try {
                    inStream.close();
                } catch (IOException e) {
                }
            }
        }
        return success;
    }

    private static boolean saveFile(String fileName, byte[] file, FTPClient client) {
        boolean success = false;
        InputStream inStream = null;
        try {
            inStream = new ByteArrayInputStream(file);
            // 对流加密
            FileDES td = FileDES.getInstance();
            inStream = td.encrypt2(inStream);
            success = client.storeFile(fileName, inStream);
            if (success == true) {
                return success;
            }
        } catch (Exception e) {
        } finally {
            if (inStream != null) {
                try {
                    inStream.close();
                } catch (IOException e) {
                }
            }
        }
        return success;
    }


    /**
     * 创建远程目录
     *
     * @param remote    远程目录
     * @param ftpClient ftp客户端
     * @return 是否创建成功
     * @throws IOException
     */
    private static boolean createDirectory(String remote, FTPClient ftpClient) throws IOException {
        String dirctory = remote.substring(0, remote.lastIndexOf("/") + 1);
        if (!dirctory.equalsIgnoreCase("/") && !ftpClient.changeWorkingDirectory(dirctory)) {
            int start = 0;
            int end = 0;
            if (dirctory.startsWith("/")) {
                start = 1;
            }
            end = dirctory.indexOf("/", start);
            while (true) {
                String subDirctory = remote.substring(start, end);
                if (!ftpClient.changeWorkingDirectory(subDirctory)) {
                    if (ftpClient.makeDirectory(subDirctory)) {
                        ftpClient.changeWorkingDirectory(subDirctory);
                    } else {
                        log.error("创建目录失败");
                        return false;
                    }
                }
                start = end + 1;
                end = dirctory.indexOf("/", start);
                if (end <= start) {
                    break;
                }
            }
        }
        return true;
    }


    public static void logout(FTPClient ftpClient) {
        // System.err.println("logout");
        if (ftpClient.isConnected()) {
            //System.err.println("logout");
            try {
                ftpClient.logout();
                disConnection(ftpClient);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 下载
     */
    public static void download(HttpServletResponse response, String ftpUrl, Integer ftpPort, String ftpUsername, String ftpPassword, String filename, String basePath) throws IOException {
        InputStream in = null;
        // 建立连接
        try {
            FTPClient ftpClient = getFtpClient(ftpUrl, ftpPort, ftpUsername, ftpPassword);
            if (ftpClient == null) {
                throw new NsBizException("FTP连接失败");
            }
            response.setContentType("application/octet-stream; charset=utf-8");
            response.setHeader("Content-Disposition", "attachment; filename=" +
                    URLEncoder.encode(filename, "UTF-8"));
            byte[] buff = new byte[1024];
            // BufferedInputStream bis = null;
            OutputStream os = response.getOutputStream();
            // ftpClient.enterLocalPassiveMode();
            // 设置传输二进制文件
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
            int reply = ftpClient.getReplyCode();
            if (!FTPReply.isPositiveCompletion(reply)) {
                ftpClient.disconnect();
                throw new IOException("failed to connect to the FTP Server:" + ftpUrl);
            }
            ftpClient.changeWorkingDirectory(basePath);
            // 获取文件列表
            FTPFile[] ftpFiles = ftpClient.listFiles(filename);
            if (ftpFiles == null || ftpFiles.length == 0) {
                log.info("远程文件不存在");
                throw new IOException("远程文件不存在");
            }
            // ftp文件获取文件
            in = ftpClient.retrieveFileStream(filename);
            // 获取文件加密解密对象
            FileDES td = FileDES.getInstance();
            // 解密文件
            td.decrypt2(in, os);
//            int i = in.read(buff);
//            while (i != -1) {
//                os.write(buff, 0, i);
//                i = in.read(buff);
//            }
            logout(ftpClient);
        } catch (FTPConnectionClosedException e) {
            throw new RemoteException("ftp连接被关闭！", e);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RemoteException("ERR : upload file " + filename + " from ftp : failed!", e);
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
    }

}
