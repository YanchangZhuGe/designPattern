package designPattern.other.test.sum;

/**
 * 描述:两个乒乓球队进行比赛
 *
 * @author WuYanchang
 * @date 2021/8/3 14:39
 */

public class test18 {
    public static void main(String[] args) {
        for (char i = 'x'; i <= 'z'; i++) {
            for (char j = 'x'; j <= 'z'; j++) {
                if (i != j) {
                    for (char k = 'x'; k <= 'z';
                         k++) {
                        if (i != k &&
                                j != k) {
                            if (i != 'x' &&
                                    j != 'x' &&
                                    j != 'z') {
                                System.out.println("a:" + i + "\nb:" + j + "\nc:" + k);
                            }
                        }
                    }
                }
            }
        }
    }
}
