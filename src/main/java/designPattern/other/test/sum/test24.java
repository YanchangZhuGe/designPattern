package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:给一个不多于5位的正整数，
 *
 * @author WuYanchang
 * @date 2021/8/3 15:27
 */

public class test24 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        String toString = input.nextLine();
        char[] num = toString.toCharArray();
        System.out.println(num.length);
        for (int i = num.length; i > 0;
             i--) {
            System.out.print(num[i - 1]);
        }
    }
}
