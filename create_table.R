setwd("/Users/Tom/Roper-iPoll/")
library(survey)
library(xtable)

f <- "rr201404.dat"
m <- "metadata.csv" # data copied from poll methodology p. 9-10. A new column with widths was manually added using Excel by 
# subtracting the end value of row m from each row m+1

meta <- read_csv(m)
data <- read.fwf(f, widths = meta$widths, col.names = meta$variable)

q_text <- "As you may know, Bitcoin is a new online digital currency that is not connected to any particular country's currency system and is not controlled by any government. Do you think the government should allow people to use Bitcoins to purchase goods and services, or not?"

# Adding labels to the column
data$Q47 <- factor(data$q47,
                  levels = c(1,2,8,9),
                  labels = c("Favor", "Oppose", "Don't know", "Refused")) 

# Note: This blog post was used to learn syntax for weighting and comparing tables: 
# https://www.r-bloggers.com/social-science-goes-r-weighted-survey-data/

# First examine the proportions in the raw data
prop.table(table(data$Q47))

# Now create a survey design object and use the weights provided
sdesign <- svydesign(ids = ~1, data = data, weights = data$WEIGHT)

# Now look at the proportions in the weighted version. These match those shown on the Roper Center website
tbl <- prop.table(svytable(~data$Q47, design = sdesign))

# Render table in Latex amd save the file
tbl_ltx <- xtable(tbl, caption = q_text)
names(tbl_ltx) <- c("% of Respondents")
print.xtable(tbl_ltx, type="latex", file="table.tex")

# Finally, call pandoc to render it to pdf and open it in pdf reader:
system("pandoc -s table.tex -o table.pdf && open table.pdf")
