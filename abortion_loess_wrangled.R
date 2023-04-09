library(readr)
library(ggplot2)
library(scales)

dat <- read_csv("CESabortiondistances22_v2.csv")

table(dat$CC22_332a)
dat$prochoice <- NA
dat$prochoice[dat$CC22_332a==1] <- 1
dat$prochoice[dat$CC22_332a==2] <- 0
table(dat$prochoice)

# Custom transformation function
custom_trans <- trans_new(
  name = "custom",
  transform = function(x) {
    ifelse(x < 15, x / 15, ifelse(x < 30, 1 + (x - 15) / 15, ifelse(x < 50, 2 + (x - 30) / 20, ifelse(x < 100, 3 + (x - 50) / 50, ifelse(x < 400, 4 + (x - 100) / 300, 5 + (x - 400) / 500)))))
  },
  inverse = function(x) {
    ifelse(x < 1, x * 15, ifelse(x < 2, 15 + (x - 1) * 15, ifelse(x < 3, 30 + (x - 2) * 20, ifelse(x < 4, 50 + (x - 3) * 50, ifelse(x < 5, 100 + (x - 4) * 300, 400 + (x - 5) * 500)))))
  }
)

# Remove rows with non-finite values in driving_distance and prochoice columns
dat_clean <- dat[is.finite(dat$driving_distance) & is.finite(dat$prochoice),]
# Define custom breaks and labels for the x-axis
breaks <- c(0, 15, 30, 50, 100, 400, 900)
labels <- c("0", "15", "30", "50", "100", "400", "900")
# Create the ggplot graph
plotPro7 <- ggplot(dat_clean, aes(x = driving_distance, y = prochoice*100, weight = commonweight)) +
  geom_smooth(aes(weight = commonweight), colour = "black", method = "loess", se = FALSE) +
  theme_bw() +
  scale_x_continuous(trans = custom_trans, breaks = breaks, labels = labels) +
  xlab("Driving Distance to nearest abortion clinic (custom scale, miles)") +
  ylab("% supporting keeping abortion legal in all circumstances") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylim(0, 100)

plotPro7

table(dat$gender4)
dat$iswoman <- NA
dat$iswoman <- 0 
dat$iswoman[dat$gender4==2] <- 1
table(dat$iswoman, dat$gender4)


table(dat$pid3)
dat$republican <- NA
dat$republican <- 0
dat$republican[dat$pid3==2] <- 1
table(dat$republican)

# Create the ggplot graph
plotPro8 <- ggplot(dat_clean, aes(x = driving_distance, y = prochoice * 100, weight = commonweight)) +
  geom_smooth(aes(weight = commonweight), colour = "black", method = "loess", se = FALSE) +
  geom_smooth(data = subset(dat_clean, republican == 0), aes(colour = factor(republican), weight = commonweight), method = "loess", se = FALSE) + 
  geom_smooth(data = subset(dat_clean, republican == 1), aes(colour = factor(republican), weight = commonweight), method = "loess", se = FALSE) +
  geom_smooth(data = subset(dat_clean, iswoman == 1), aes(colour = factor(iswoman + 2), weight = commonweight), method = "loess", se = FALSE) +
  theme_bw() +
  scale_x_continuous(trans = custom_trans, breaks = breaks, labels = labels) +
  scale_colour_manual(values = c("gray", "darkred", "pink"), labels = c("Non-Republican", "Republican", "Woman")) +
  xlab("Driving Distance to nearest abortion clinic (custom scale, miles)") +
  ylab("% supporting keeping abortion legal in all circumstances") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylim(0, 100)

plotPro8