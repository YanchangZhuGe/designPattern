package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:取一个整数a从右端开始的4～7位
 *
 * @author WuYanchang
 * @date 2021/8/6 15:01
 */

public class test32 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        String toString = input.nextLine();
        char[] a = toString.toCharArray();
        int j = a.length;
        if (j <
                7) {
            System.out.println("error!");
        }
        System.out.println(a[j - 7] + "" + a[j - 6] + "" + a[j - 5] + "" + a[j - 4]);
    }
}
