package designPattern.other.test.sum;

import java.util.Arrays;
import java.util.Scanner;

/**
 * 描述:已经排好序的数组
 *
 * @author WuYanchang
 * @date 2021/8/3 15:31
 */

public class test30 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[] a = new int[10];
        for (int i = 0; i < 10; i++) {
            a[i] = input.nextInt();
        }
        Arrays.sort(a);
        for (int i = 0; i < 10; i++) {
            System.out.println(a[i]);
        }
        int x = input.nextInt();
        a = sort(a, x);
        for (int i = 0; i < a.length; i++) {
            System.out.println(a[i]);
        }
    }

    public static int[] sort(int[] a, int b) {
        int[] c = new int[a.length + 1];
        boolean flag = true;
        for (int i = 0; i < a.length; i++) {
            if (flag) {
                if (a[i] <
                        b) {
                    c[i] = a[i];
                } else {
                    c[i] = b;
                    flag = false;
                    System.arraycopy(a, i, c, i + 1, a.length - i);
                }
            } else {
                break;
            }
        }
        return c;
    }


}
