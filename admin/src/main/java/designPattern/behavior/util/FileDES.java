package designPattern.behavior.util;

import javax.crypto.*;
import javax.crypto.spec.GCMParameterSpec;
import java.io.*;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.UUID;

public class FileDES {
    // 定义常量
    private static final String DES_KEY = "AES";
    private static final String AES_CIPHER_GCM_NO_PADDING = "AES/GCM/NoPadding";
    private static final String initKey = "P@ssW0rd";
    private volatile static FileDES instance;

    FileDES() {
        System.out.println("Singleton has loaded");
    }

    public static FileDES getInstance() {
        if (instance == null) {
            synchronized (FileDES.class) {
                if (instance == null) {
                    instance = new FileDES();
                }
            }
        }
        return instance;
    }

    private Cipher init(byte[] initKey, int modes) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, InvalidKeyException {
        // key生成器
        KeyGenerator keyGenerator = KeyGenerator.getInstance(DES_KEY);
        // 加密因子
        SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG");
        secureRandom.setSeed(initKey);
        keyGenerator.init(secureRandom);
        SecretKey secretKey = keyGenerator.generateKey();
        // 初始化GCM
        GCMParameterSpec encryptSpec = new GCMParameterSpec(128, initKey);
        Cipher cipher = Cipher.getInstance(AES_CIPHER_GCM_NO_PADDING);
        cipher.init(modes, secretKey, encryptSpec);
        return cipher;
    }

    /**
     * 文件file进行加密并保存目标文件destFile中
     *
     * @param file     要加密的文件 如c:/test/srcFile.txt
     * @param destFile 加密后存放的文件名 如c:/加密后文件.txt
     */
    public void encrypt(String file, String destFile) {
        CipherInputStream cis = null;
        OutputStream out = null;
        InputStream is = null;
        try {
            Cipher cipher = init(initKey.getBytes("UTF-8"), Cipher.ENCRYPT_MODE);
            is = new FileInputStream(file);
            out = new FileOutputStream(destFile);
            cis = new CipherInputStream(is, cipher);
            byte[] buffer = new byte[1024];
            int r;
            while ((r = cis.read(buffer)) > 0) {
                out.write(buffer, 0, r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cis != null) {
                    cis.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (is != null) {
                    is.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


    }

    /**
     * 文件采用DES算法解密文件
     *
     * @param file 已加密的文件 如c:/加密后文件.txt
     *             * @param destFile
     *             解密后存放的文件名 如c:/ test/解密后文件.txt
     */
    public void decrypt(String file, String dest) throws Exception {
        InputStream is = null;
        OutputStream out = null;
        CipherOutputStream cos = null;
        try {
            Cipher cipher = init(initKey.getBytes("UTF-8"), Cipher.DECRYPT_MODE);
            is = new FileInputStream(file);
            out = new FileOutputStream(dest);
            cos = new CipherOutputStream(out, cipher);
            byte[] buffer = new byte[1024];
            int r;
            while ((r = is.read(buffer)) >= 0) {
                cos.write(buffer, 0, r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cos != null) {
                    cos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (is != null) {
                    is.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 上传加密(使用中)
     *
     * @param file
     * @param destFile
     * @throws Exception
     */
    public void encrypt(File file, String destFile) {
        InputStream is = null;
        OutputStream out = null;
        CipherInputStream cis = null;
        try {
            Cipher cipher = init(initKey.getBytes("UTF-8"), Cipher.ENCRYPT_MODE);
            // cipher.init(Cipher.ENCRYPT_MODE, getKey());
//            cipher.init(Cipher.ENCRYPT_MODE, this.key);
            is = new FileInputStream(file);
            out = new FileOutputStream(destFile);
            cis = new CipherInputStream(is, cipher);
            byte[] buffer = new byte[1024];
            int r;
            while ((r = cis.read(buffer)) > 0) {
                out.write(buffer, 0, r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cis != null) {
                    cis.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (is != null) {
                    is.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 上传加密(使用中)
     *
     * @param destFile
     * @throws Exception
     */
    public void encrypt2(InputStream in, String destFile) {
        OutputStream out = null;
        CipherInputStream cis = null;
        try {
            Cipher cipher = init(initKey.getBytes("UTF-8"), Cipher.ENCRYPT_MODE);
            out = new FileOutputStream(destFile);
            cis = new CipherInputStream(in, cipher);
            byte[] buffer = new byte[1024];
            int r;
            while ((r = cis.read(buffer)) > 0) {
                out.write(buffer, 0, r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cis != null) {
                    cis.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (in != null) {
                    in.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    /**
     * 文件file进行加密并保存目标文件destFile中
     */
    public InputStream encrypt2(InputStream in) {
        CipherInputStream cis = null;
        try {
            Cipher cipher = init(initKey.getBytes("UTF-8"), Cipher.ENCRYPT_MODE);
            cis = new CipherInputStream(in, cipher);
            return cis;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 下载解密（使用中）
     *
     * @param is
     * @return
     * @throws Exception
     */
    public String decrypt(InputStream is) throws Exception {
        String returnPath = "";
        Cipher cipher = init(initKey.getBytes("UTF-8"), Cipher.DECRYPT_MODE);

        File temp = File.createTempFile(UUID.randomUUID().toString(), "");
        OutputStream out = new FileOutputStream(temp);
        final CipherOutputStream cos = new CipherOutputStream(out, cipher);

        //ByteArrayInputStream  res=new ByteArrayInputStream (((OutputStream)cos).toByteArray());
        byte[] buffer = new byte[1024];
        int r;
        while ((r = is.read(buffer)) >= 0) {
            cos.write(buffer, 0, r);
        }
        returnPath = temp.getAbsolutePath();
        cos.close();
        out.close();
        is.close();
        return returnPath;
    }

    public static void main(String[] args) throws Exception {
        FileDES td = FileDES.getInstance();
//        td.encrypt("D:\\删除触发器.sql", "D:\\删除触发器2.sql"); //加密
        td.decrypt("D:\\删除触发器2.sql", "D:\\删除触发器3.sql"); //解密

    }

    public void decrypt2(InputStream in, OutputStream out) {

        CipherOutputStream cos = null;
        try {
            Cipher cipher = init(initKey.getBytes("UTF-8"), Cipher.DECRYPT_MODE);
            cos = new CipherOutputStream(out, cipher);
            byte[] buffer = new byte[1024];
            int r;
            while ((r = in.read(buffer)) >= 0) {
                cos.write(buffer, 0, r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cos != null) {
                    cos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (in != null) {
                    in.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
