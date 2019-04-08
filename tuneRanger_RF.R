install.packages("devtools")
devtools::install_github("PhilippPro/tuneRanger")
library(tuneRanger)
install.packages("mlr")
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
                iters =70,
                iters.warmup =30)

res

res$model

###########
#randomForest mit Vorschlag von res erstellen
#num.trees = ntree

install.packages("randomForest")
library(randomForest)
rfmod1<-randomForest(train$target~.,data=train,num.threads=2,verbose=FALSE,
                     respect.unordered.factors=order,mtry=24,min.node.size=3,
                     sample.fraction=0.202,num.trees=1e+03,replace=FALSE)
?randomForest

#predict und speichern in submission

ypred<-predict(rfmod1,test)
ypred
submission$target<-ypred
fwrite(submission,"../Pfad/submission.csv")
