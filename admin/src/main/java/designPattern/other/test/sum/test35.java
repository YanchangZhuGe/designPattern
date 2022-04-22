package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:输入数组，最大的与第一个元素交换
 *
 * @author WuYanchang
 * @date 2021/8/6 15:04
 */

public class test35 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[] a = new int[5];
        for (int i = 0; i < a.length; i++) {
            a[i] = input.nextInt();
        }
        for (int i = 0; i < a.length; i++) {
            System.out.println(a[i]);
        }
        int maxi = 0;
        int max = a[maxi];
        for (int i = 1; i < a.length; i++) {
            if (max <
                    a[i]) {
                max = a[i];
                maxi = i;
            }
        }
        int t = a[0];
        a[0] = a[maxi];
        a[maxi] = t;
        int mini = 0;
        int min = a[mini];
        for (int i = 1; i < a.length; i++) {
            if (min >
                    a[i]) {
                min = a[i];
                mini = i;
            }
        }
        int k = a[a.length - 1];
        a[a.length - 1] = a[mini];
        a[mini] = k;
        for (int i = 0; i < a.length; i++) {
            System.out.println(a[i]);
        }
    }
}
