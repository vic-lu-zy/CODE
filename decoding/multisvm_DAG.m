function [result] = multisvm_DAG(TestSet,TrainingSet,GroupTrain)

u = unique(GroupTrain);
C = nchoosek(u,2); % coeff matrix for one-to-one comparison

result = zeros(size(TestSet,1),1);
interm = zeros(size(TestSet,1),size(C,1));

%% build models

for ii = 1:size(C,1)
    
    ind = GroupTrain==C(ii,1) | GroupTrain==C(ii,2);
    Y = GroupTrain(ind) == C(ii,1);
    X = TrainingSet(ind,:);
    model = fitcsvm(X,Y);
    interm(:,ii) = model.predict(TestSet);
    
end

%% classify test cases

for jj=1:size(TestSet,1)
    
    if interm(jj,1)             % not 2
        if interm(jj,2)             % not 3
            if interm(jj,3)             % not 4
                result(jj) = 1;
            else                        % not 1
                result(jj) = 4;
            end
        else                        % not 1
            if interm(jj,6)             % not 4
                result(jj) = 3;
            else                        % not 3
                result(jj) = 4;
            end
        end
    else                        % not 1
        if interm(jj,4)             % not 3
            if interm(jj,5)             % not 4
                result(jj) = 2;
            else                        % not 2
                result(jj) = 4;
            end
        else                        % not 2
            if interm(jj,6)             % not 4
                result(jj) = 3;
            else                        % not 3
                result(jj) = 4;
            end
        end
        
        
    end
end