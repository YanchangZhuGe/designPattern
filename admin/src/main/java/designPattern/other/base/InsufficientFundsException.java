package designPattern.other.base;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/23 16:21
 */

public class InsufficientFundsException extends Throwable {
    //此处的amount用来储存当出现异常（取出钱多于余额时）所缺乏的钱
    private double amount;

    public InsufficientFundsException(double amount) {
        this.amount = amount;
    }

    public double getAmount() {
        return amount;
    }

}
