package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:水仙花数
 *
 * @author WuYanchang
 * @date 2021/7/19 11:01
 */

public class test04 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int n = input.nextInt();
        int k = 2;
        while (n <= k) {
            if (n == k) {
                System.out.println(k);
                break;
            } else if (n % k == 0) {
                System.out.println(k);
                n = n / k;
            } else {
                k++;
            }
        }
    }

}
