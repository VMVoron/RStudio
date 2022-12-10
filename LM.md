## Data sets for linear regression https://people.sc.fsu.edu/~jburkardt/datasets/regression/regression.html
## current_file https://github.com/VMVoron/RStudio/blob/main/x03.txt
# Данный файл содержит показатели: возраст человека, кровяное давление
# Построим парную линейную регрессию зависимости давления от возраста 
```{r}
data <- read.table('x03.txt',              # TXT data file indicated as string or full path to the file
           header = TRUE)         # Character used to separate decimals of the numbers in the file
#checking if reading is in correct format
head(data)
```
 Output
```{r}
  Index One Age Blood_Pressure
1     1   1  39            144
2     3   1  45            138
3     4   1  47            145
4     5   1  65            162
5     6   1  46            142
6     7   1  67            170
```
## Calculating the parameters of linear regression using lm
```{r}
lm.data <- lm(formula = Blood_Pressure ~ Age, data = data)
lm.data$coefficients
```
 Output
```{r}
(Intercept)         Age 
 97.0770843   0.9493225
 ```
# Linear regression model -97.0771 + 0.9493 * Age
## То есть увеличение возраста на 10 лет увеличивает давление примерно на 9.5 единиц
```{r}
b0 <- lm.data$coefficient[1]
b1 <- lm.data$coefficient[2]
x1 <- as.numeric(min(data$Age))
x2 <- as.numeric(max(data$Age))
x <- seq(from = x1, to = x2, length.out = 70)
y <- b0 + b1*x
plot(data$Age, data$Blood_Pressure, main="Pair linear regression", xlab="Age (years)", ylab="Blood pressure (systolic)")
grid()
lines(x, y, col="red")
```
![png](https://github.com/VMVoron/RStudio/blob/main/LM.png)
```{r}
summary(lm.data)
```
Output
```{r}
Call:
lm(formula = Blood_Pressure ~ Age, data = data)

Residuals:
    Min      1Q  Median      3Q     Max 
-19.354  -4.797   1.254   4.747  21.153 
---
```

Наибольшее положительное наблюдаемое отклонение от модельного: 21.153 пункта давления, \
Наибольшее отрицательное: -19.354
---
Output
```{r}
Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  97.0771     5.5276  17.562 2.67e-16 ***
Age           0.9493     0.1161   8.174 8.88e-09 ***

Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```
Все коэффициенты значимы на уровне p-value < 0.001, это отмечено тремя звездочками (***) в выводе в таблице "Coefficients"
А также можно заметить низкие значение p-value самостоятельно в той же таблице Pr(>|t|) : 2.67e-16, 8.88e-09
---
Output
```{r}
Residual standard error: 9.563 on 27 degrees of freedom
Multiple R-squared:  0.7122,	Adjusted R-squared:  0.7015 
F-statistic: 66.81 on 1 and 27 DF,  p-value: 8.876e-09
```

## Коэффициент детерминации, или R² 
(иногда читаемый как R-два), является еще одним показателем, который мы можем использовать для оценки модели, \
R² всегда будет между -∞ и 1 \
Среднеквадратичное отклонение (Adj. R-squared: 0.7015). Его значение довольно близко к единице, можно сказать, что модель довольно значима\
Имеем степени свободы 1 и 27 \
## Посмотрим на F-критерий Фишера \
> F табл (a, k1, k2): a - значимость, k1 - количество факторов, k2 = n-k1-1
> k1 = 1, k2 = 29-2 = 27
### F табличное при уровне значимости 0.01 = 7.6, 66.81 > 7.6, значимость подтверждена по критерию Фишера
```
 ```
