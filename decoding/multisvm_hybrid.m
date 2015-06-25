function result = multisvm_hybrid(TestSet,TrainingSet,GroupTrain,numOfFeatures)

switch length(unique(GroupTrain))
    
    case 2
        
        fun = @binarysvm;
        
    case 3
        
        fun = @multisvm_OvO;
        
    case 4
        
        fun = @multisvm_DAG;
        
end

result = fun(TestSet,TrainingSet,GroupTrain,numOfFeatures);
