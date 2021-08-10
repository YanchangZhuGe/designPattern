package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:有n个人围成一圈，顺序排号。
 *
 * @author WuYanchang
 * @date 2021/8/10 19:30
 */

public class test37 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int n = input.nextInt();
        boolean[] arr = new boolean[n];
        for (int i = 0; i < arr.length; i++) {
            arr[i] = true;
        }
        int leftCount = n;
        int index = 0;
        int countNum = 0;
        while (leftCount >
                1) {
            if (arr[index] == true) {
                countNum++;
                if (countNum == 3) {
                    arr[index] = false;
                    leftCount--;
                    countNum = 0;
                }
            }
            index++;
            if (index == n) {
                index = 0;
            }
        }
        for (int i = 0; i < n; i++) {
            if (arr[i] == true) {
                System.out.println(i + 1);
            }
        }
    }
}
