package designPattern.other.test.sum;

/**
 * 描述:菱形
 *
 * @author WuYanchang
 * @date 2021/8/3 14:40
 */

public class test19 {
    public static void main(String[] args) {
        int H = 7, W = 7; //高和宽必须是相等的奇数
        for (int i = 0; i < (H + 1) / 2; i++) {
            for (int j = 0; j < W / 2 - i; j++) {
                System.out.print(" ");
            }
            for (int k = 1; k < (i + 1) * 2;
                 k++) {
                System.out.print('*');
            }
            System.out.println();
        }
        for (int i = 1; i <= H / 2; i++) {
            for (int j = 1; j <= i; j++) {
                System.out.print(" ");
            }
            for (int k = 1; k <= W - 2 * i;
                 k++) {
                System.out.print('*');
            }
            System.out.println();
        }
    }
}
