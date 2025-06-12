package cn.twinkling.stream.util;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

/**
 * Key Util: 1> according file name|size ..., generate a key;
 * 			 2> the key should be unique.
 */
public class TokenUtil {

	/**
	 * ����Token�� A(hashcode>0)|B + |name��Hashֵ| +_+size��ֵ
	 * @param name
	 * @param size
	 * @return
	 * @throws Exception
	 */
	public static String generateToken(String name, String size,HttpServletRequest req)
			throws IOException {
		if (name == null || size == null)
			return "";
		int code = name.hashCode();
		try {
			String token = (code > 0 ? "A" : "B") + Math.abs(code) + "_" + size.trim();
			/** TODO: store your token, here just create a file */
			IoUtil.storeToken(token,req);
			return token;
		} catch (Exception e) {
			throw new IOException(e);
		}
	}
}
