```{r}
vehicles <- read.csv('C:\\vehicles.csv', stringsAsFactors = FALSE)
head(vehicles)
table(vehicles$trany)
vehicles$trany2<-ifelse(substr(vehicles$trany,1,4)=="Auto","Auto","Manual")
head(vehicles$trany2)
library(dplyr)
table(vehicles$trany2)
library(lattice)

yscale.components.custom <- function (lim, logsc = FALSE, ...) {
  ans <- yscale.components.default(lim, logsc = logsc, ...)
  ans$left$labels$labels <- format(ans$left$labels$at*1000)
  ans
}

histogram(~city08|fuelType1,data=vehicles, type="density", main = 'Гистограмма', xlab = 'Миль на галлоне (city08)', ylab = 'доля', col = 'coral', pch=".", layout=c(3, 2), aspect=1, index.cond=list(6:1), yscale.components = yscale.components.custom)

vehicles$trany2 <- as.factor(vehicles$trany2)
vehicles$fuelType1 <-as.factor(vehicles$fuelType1)
is.factor(vehicles$trany2)
is.factor(vehicles$fuelType1)

vehicles$sCharger1 <- ifelse((vehicles$sCharge == 'S'), 1, 0)
vehicles$tCharger1 <- ifelse((is.na(vehicles$tCharger) == TRUE), 0, 1)


cols <- c("sCharger")
dat <- vehicles %>%
  group_by(year) %>%
  summarize(x=sum(sCharger1))

library(ggplot2)

ggplot(data = groups, mapping = aes(x = dat$year, y = dat$x), xlab = "Body size") + ggtitle('Количество машин с нагнетателями по годам') + geom_point() + geom_line() + xlab("Год") + ylab("Количество")
```
![png](https://i.ibb.co/vYc1Jmt/plot-zoom.png)
