library(dplyr)
library(reshape)

## load the data ## загружаем данные
train_data <- read.table( "train/X_train.txt")

## Read variables names from features ## Считываем имена переменных
col_names <- read.table( "features.txt")

## Make syntactically valid names out of character vectors
## Делаем имена синтаксически правильными
colnames(train_data) <-  make.names(col_names[[2]], unique = TRUE)

## Select columns whose names contains the mean and standard deviation
train_data_filtered <- select( .data = train_data, contains("mean"), contains("std"))
rm(train_data)

activity <- read.table( "train/Y_train.txt")
subj <- read.table( "train/subject_train.txt")

train_data_filtered$ActivityID <- activity[[1]]
train_data_filtered$SubjectID <- subj[[1]]

train_data_molten <- melt(train_data_filtered, id = c("ActivityID", "SubjectID"))
train_data_groupped <- group_by(train_data_molten,ActivityID,SubjectID,variable) %>%  summarize( mean(value))


test_data <- read.table( "test/X_test.txt")
colnames(test_data) <-  make.names(col_names[[2]], unique = TRUE)

test_data_filtered <- select( .data = test_data, contains("mean"), contains("std"))
rm(test_data)

activity <- read.table( "test/Y_test.txt")
subj <- read.table( "test/subject_test.txt")

test_data_filtered$ActivityID <- activity[[1]]
test_data_filtered$SubjectID <- subj[[1]]

test_data_molten <- melt(test_data_filtered, id = c("ActivityID", "SubjectID"))
test_data_groupped <- group_by(test_data_molten,ActivityID,SubjectID,variable) %>%  summarize( mean(value))

data <- bind_rows(train_data_groupped, test_data_groupped)
write.table(data, file = "tiny_data.txt", row.name=FALSE)