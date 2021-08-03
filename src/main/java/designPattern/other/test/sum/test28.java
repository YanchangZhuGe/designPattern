package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:对10个数进行排序
 *
 * @author WuYanchang
 * @date 2021/8/3 15:30
 */

public class test28 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[] a = new int[10];
        for (int i = 0; i < 10; i++) {
            a[i] = input.nextInt();
        }
        int[] b = paixu(a);
        for (int i = 0; i < b.length; i++) {
            System.out.println(b[i]);
        }
    }

    public static int[] paixu(int[] a) {
        for (int i = 0; i < a.length; i++) {
            for (int j = i; j < a.length; j++) {
                if (a[i] >
                        a[j]) {
                    int t = a[j];
                    a[j] = a[i];
                    a[i] = t;
                }
            }
        }
        return a;
    }

}
