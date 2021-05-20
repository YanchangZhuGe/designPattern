package designPattern.creativion.builder;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/20 15:04
 */

public class MealBuilder {
    public Meal prepareVegMeal() {

        Meal meal = new Meal();
        meal.addItem(new VegBurger());
        meal.addItem(new Coke());
        return meal;
    }

    public Meal prepareNonVegMeal() {
        Meal meal = new Meal();
        meal.addItem(new ChickenBurger());
        meal.addItem(new Pepsi());
        return meal;
    }

}
