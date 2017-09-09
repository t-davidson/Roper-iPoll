setwd("/Users/Tom/Roper-iPoll/")
library(readr)
library(haven)
library(survey)
library(Hmisc)
library(xtable)

f <- "rr201404.dat"
f2 <- "rr201404.por"

# TODO: Figure out how to read in the .dat file
#data <- read_delim(f, delim = ' ')

data <- read_spss(f2)

q_text <- "As you may know, Bitcoin is a new online digital currency that is not connected to any particular country's currency system and is not controlled by any government. Do you think the government should allow people to use Bitcoins to purchase goods and services, or not?"
# Labelling the variable of interest
label(data$Q47) <-  q_text

# Labelling the labels of the column
# Note that labels already exist in SPSS  version
data$Q47 <- factor(data$Q47,
                  levels = c(1,2,8,9),
                  labels = c("Favor", "Oppose", "Don't know", "Refused")) 

# Note: This blog post was used to learn syntax for weighting and comparing tables: 
# https://www.r-bloggers.com/social-science-goes-r-weighted-survey-data/

# First examine the proportions in the raw data
prop.table(table(data$Q47))

# Now create a survey design object and use the weights provided
sdesign <- svydesign(ids = ~1, data = data, weights = data$WEIGHT)

# Now look at the proportions in the weighted version:
tbl <- prop.table(svytable(~data$Q47, design = sdesign))

# Render as Latex
tbl_ltx <- xtable(tbl, caption = q_text)
names(tbl_ltx) <- c("% of Respondents")

# Export file 
print.xtable(tbl_ltx, type="latex", file="table.tex")

# Finally, call pandoc to render it to pdf and open it in pdf reader:
system("pandoc -s table.tex -o table.pdf && open table.pdf")


