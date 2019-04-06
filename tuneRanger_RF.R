library(data.table)

train <- read.table("../Pfad/train.csv",header=T,sep=",")
test <- read.table("../Pfad/test.csv",header=T,sep=",")
submission <- read.table("../Pfad/submission.csv",header=T,sep=",")



set.seed(42)
install.packages("devtools")
install.packages("rlang")
install.packages("mlr")
library(devtools)
library(rlang)
devtools::install_github("PhilippPro/tuneRanger")
library(tuneRanger)
library(mlr)
# A mlr task has to be created in order to use the package
#data(train)
train<-train[0:150,]

#ID Code entfernen weil unnötig
train$ID_code<-NULL
#train$target<-as.factor(train$target)
#na.omit(train)
train.task = makeRegrTask(data = train, target ="target")
?makeClassifTask

estimateTimeTuneRanger(train.task)

res =tuneRanger(train.task, 
                 
                num.trees =3000,
                num.threads =2,
                iters =200,
                iters.warmup =30)
#measure =list(multi),
?tuneRanger

res

res$model

###########
#randomForest mit Vorschlag von res erstellen
#num.trees = ntree

install.packages("randomForest")
library(randomForest)
rfmod1<-randomForest(train$target~.,data=train,ntree=3000,mtry=1,nodesize=2)
?randomForest

#predict und speichern in submission

ypred<-predict(rfmod1,test)
ypred
submission$target<-ypred
fwrite(submission,"../Pfad/submission.csv")
