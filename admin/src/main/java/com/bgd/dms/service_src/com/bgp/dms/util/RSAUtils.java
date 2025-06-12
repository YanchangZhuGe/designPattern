package com.bgp.dms.util;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
 
import javax.crypto.Cipher;

 
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.net.util.Base64;

 
/**
* @author ����:LYH
* @createDate ����ʱ�䣺2018��8��10�� ����11:18:21
*/
public class RSAUtils {
    protected static final Log log = LogFactory.getLog(RSAUtils.class);
    private static String KEY_RSA_TYPE = "RSA";
    private static int KEY_SIZE = 1024;//JDK��ʽRSA�������ֻ��1024λ
    private static int ENCODE_PART_SIZE = KEY_SIZE/8;
    public static final String PUBLIC_KEY_NAME = "public";
    public static final String PRIVATE_KEY_NAME = "private";
    
    public static String PUBLIC_KEY= "RSA";
    
    public static String PRIVATE_KEY= "RSA";
    
    static{
    	createRSAKeys();
    }
    
    public static ThreadLocal<String> sceneThreadLocal = new ThreadLocal<String>();
    /**
     * ������Կ��Կ
     * @return
     */
    private  static Map<String,String> createRSAKeys(){
        Map<String,String> keyPairMap = new HashMap<String,String>();//�����Ź�˽��Կ��Base64λ����
        try {
            KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(KEY_RSA_TYPE);
            keyPairGenerator.initialize(KEY_SIZE,new SecureRandom());
            KeyPair keyPair = keyPairGenerator.generateKeyPair();
 
            //��ȡ��Կ��Կ
             PUBLIC_KEY = Base64.encodeBase64String(keyPair.getPublic().getEncoded()).replaceAll("[\\s\\t\\n\\r]", "");
             PRIVATE_KEY = Base64.encodeBase64String(keyPair.getPrivate().getEncoded()).replaceAll("[\\s\\t\\n\\r]", "");
            //���빫Կ��Կ���Ա��Ժ��ȡ
            //keyPairMap.put(PUBLIC_KEY_NAME,publicKeyValue);
            //keyPairMap.put(PRIVATE_KEY_NAME,privateKeyValue);
        } catch (NoSuchAlgorithmException e) {
            log.error("��ǰJDK�汾û�ҵ�RSA�����㷨��");
            e.printStackTrace();
        }
        return keyPairMap;
    }
 
    /**
     * ��Կ����
     * ������
     *     1�ֽ� = 8λ��
     *     �����ܳ����� 1024λ˽Կʱ�������ܳ���Ϊ 128-11 = 117�ֽڣ����ܶ೤���ݣ����ܳ������� 128 �ֽڳ��ȡ�
     * @param sourceStr
     * @param publicKeyBase64Str
     * @return
     */
    public static String encode(String sourceStr,String publicKeyBase64Str){
        byte [] publicBytes = Base64.decodeBase64(publicKeyBase64Str);
        //��Կ����
        X509EncodedKeySpec x509EncodedKeySpec = new X509EncodedKeySpec(publicBytes);
        List<byte[]> alreadyEncodeListData = new LinkedList<byte[]>();
 
        int maxEncodeSize = ENCODE_PART_SIZE - 11;
        String encodeBase64Result = null;
        try {
            KeyFactory keyFactory = KeyFactory.getInstance(KEY_RSA_TYPE);
            PublicKey publicKey = keyFactory.generatePublic(x509EncodedKeySpec);
            Cipher cipher = Cipher.getInstance(KEY_RSA_TYPE);
            cipher.init(Cipher.ENCRYPT_MODE,publicKey);
            byte[] sourceBytes = sourceStr.getBytes("utf-8");
            int sourceLen = sourceBytes.length;
            for(int i=0;i<sourceLen;i+=maxEncodeSize){
                int curPosition = sourceLen - i;
                int tempLen = curPosition;
                if(curPosition > maxEncodeSize){
                    tempLen = maxEncodeSize;
                }
                byte[] tempBytes = new byte[tempLen];//�����ֶܷ�����
                System.arraycopy(sourceBytes,i,tempBytes,0,tempLen);
                byte[] tempAlreadyEncodeData = cipher.doFinal(tempBytes);
                alreadyEncodeListData.add(tempAlreadyEncodeData);
            }
            int partLen = alreadyEncodeListData.size();//���ܴ���
 
            int allEncodeLen = partLen * ENCODE_PART_SIZE;
            byte[] encodeData = new byte[allEncodeLen];//�������RSA�ֶμ�������
            for (int i = 0; i < partLen; i++) {
                byte[] tempByteList = alreadyEncodeListData.get(i);
                System.arraycopy(tempByteList,0,encodeData,i*ENCODE_PART_SIZE,ENCODE_PART_SIZE);
            }
            encodeBase64Result = Base64.encodeBase64String(encodeData);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return encodeBase64Result;
    }
 
    /**
     * ˽Կ����
     * @param sourceBase64RSA
     * @param privateKeyBase64Str
     */
    public static String decode(String sourceBase64RSA,String privateKeyBase64Str){
        byte[] privateBytes = Base64.decodeBase64(privateKeyBase64Str);
        byte[] encodeSource = Base64.decodeBase64(sourceBase64RSA);
        int encodePartLen = encodeSource.length/ENCODE_PART_SIZE;
        List<byte[]> decodeListData = new LinkedList<byte[]>();//���н�������
        String decodeStrResult = null;
        //˽Կ����
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(privateBytes);
        try {
            KeyFactory keyFactory = KeyFactory.getInstance(KEY_RSA_TYPE);
            PrivateKey privateKey = keyFactory.generatePrivate(pkcs8EncodedKeySpec);
            Cipher cipher = Cipher.getInstance(KEY_RSA_TYPE);
            cipher.init(Cipher.DECRYPT_MODE,privateKey);
            int allDecodeByteLen = 0;//��ʼ�����б��������ݳ���
            for (int i = 0; i < encodePartLen; i++) {
                byte[] tempEncodedData = new byte[ENCODE_PART_SIZE];
                System.arraycopy(encodeSource,i*ENCODE_PART_SIZE,tempEncodedData,0,ENCODE_PART_SIZE);
                byte[] decodePartData = cipher.doFinal(tempEncodedData);
                decodeListData.add(decodePartData);
                allDecodeByteLen += decodePartData.length;
            }
            byte [] decodeResultBytes = new byte[allDecodeByteLen];
            for (int i = 0,curPosition = 0; i < encodePartLen; i++) {
                byte[] tempSorceBytes = decodeListData.get(i);
                int tempSourceBytesLen = tempSorceBytes.length;
                System.arraycopy(tempSorceBytes,0,decodeResultBytes,curPosition,tempSourceBytesLen);
                curPosition += tempSourceBytesLen;
            }
            decodeStrResult = new String(decodeResultBytes,"UTF-8");
        }catch (Exception e){
            e.printStackTrace();
        }
        return decodeStrResult;
    }
    
     
}