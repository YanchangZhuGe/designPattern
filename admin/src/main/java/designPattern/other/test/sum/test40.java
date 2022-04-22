package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:字符串排序
 *
 * @author WuYanchang
 * @date 2021/8/10 19:31
 */

public class test40 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        String[] toStrings = new String[5];
        String temp = null;
        toStrings[0] = "afdfdcv";
        toStrings[1] = "ghaf";
        toStrings[2] = "fdasfas";
        toStrings[3] = "tyrdfas";
        toStrings[4] = "fadsfsd";
        for (int i = 0; i < 5; i++) {
            for (int j = i + 1; j < 5; j++) {
                if (!compare(toStrings[i], toStrings[j])) {
                    temp = toStrings[i];
                    toStrings[i] = toStrings[j];
                    toStrings[j] = temp;
                }
            }
        }
        for (int i = 0; i < 5; i++) {
            System.out.println(toStrings[i]);
        }
    }

    public static boolean compare(String s1, String s2) {
        boolean flag = true;
        for (int i = 0; i < s1.length() && i < s2.length(); i++) {
            if (s1.charAt(i) >
                    s2.charAt(i)) {
                flag = false;
                break;
            } else if (s1.charAt(i) < s2.charAt(i)) {
                flag = true;
                break;
            } else {
                if (s1.length() <
                        s2.length()) {
                    flag = true;
                    break;
                } else {
                    flag = false;
                    break;
                }
            }
        }
        return flag;
    }

}
