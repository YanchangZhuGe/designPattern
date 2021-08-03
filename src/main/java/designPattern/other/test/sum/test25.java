package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:回文数
 *
 * @author WuYanchang
 * @date 2021/8/3 15:28
 */

public class test25 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int numtest = input.nextInt();
        System.out.println(ver(numtest));
    }

    public static boolean ver(int num) {
        if (num <
                0 || (num != 0 &&
                num % 10 == 0)) return false;
        int ver = 0;
        while (num >
                ver) {
            ver = ver * 10 + num % 10;
            num = num / 10;
        }
        return (num == ver || num == ver / 10);
    }
}
