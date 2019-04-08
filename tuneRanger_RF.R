install.packages("devtools")
devtools::install_github("PhilippPro/tuneRanger")
library(tuneRanger)
library(mlr)
library(data.table)

train <- read.table("../Pfad/train.csv",header=T,sep=",")
test <- read.table("../Pfad/test.csv",header=T,sep=",")
submission <- read.table("../Pfad/submission.csv",header=T,sep=",")



set.seed(42)

# A mlr task has to be created in order to use the package

train<-train[0:150,]

#ID Code entfernen weil unnötig
train$ID_code<-NULL

train.task = makeClassifTask(data = train, target ="target")
makeClassifTask

estimateTimeTuneRanger(train.task)

res =tuneRanger(train.task,
                measure =list(multiclass.brier),
                num.trees =3000,
                num.threads =2,
                iters =200,
                iters.warmup =30)

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
