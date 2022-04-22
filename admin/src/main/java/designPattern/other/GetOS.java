package designPattern.other;

import java.io.File;
import java.io.InputStreamReader;
import java.io.LineNumberReader;

/**
 * 描述: 获取操作系统
 *
 * @author WuYanchang
 * @date 2021/6/15 9:56
 */

public class GetOS {

    static class ShellUtil {
        public static String runShell(String shStr) {
            StringBuffer result = new StringBuffer();

            try {
                Process process = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", shStr}, (String[]) null, (File) null);
                InputStreamReader ir = new InputStreamReader(process.getInputStream());
                LineNumberReader input = new LineNumberReader(ir);
                process.waitFor();

                String line;
                while ((line = input.readLine()) != null) {
                    result.append(line);
                }
            } catch (Exception var6) {
                result.append("window");
            }

            return result.toString();
        }
    }

    public static void main(String[] args) {
        String operatingSystem = ShellUtil.runShell("cat /etc/issue");
        System.out.println("操作系统：" + operatingSystem);
    }

}
