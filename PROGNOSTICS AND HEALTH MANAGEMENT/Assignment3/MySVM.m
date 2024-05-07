% SVM, one-versus-rest strategy. Train  four SVM Classifiers.
function [AcR1Sum,AcR2Sum,AcR3Sum,AcR4Sum] = MySVM(n_test,XNorm,Label,LabelName)
AcR1Sum = 0; AcR2Sum = 0; AcR3Sum = 0; AcR4Sum = 0;
CM = zeros(4,4); %confusion matric
for j = 1:n_test %generate random data
    X = []; L = [];
    for i = 1:4 %Shuffel the order and make sure samples in training and testing different.
        XTemp = XNorm(1+(i-1)*30:i*30, :);
        LTemp = Label(1+(i-1)*30:i*30, :);
        X = [X; XTemp(randperm(30), :)];
        L = [L; LTemp(randperm(30), :)];
    end
    XTrain = []; LabelTrain = [];
    XTest = []; LabelTest = [];
    for i = 1:4 %10 for training and 20 for testing.
        XTemp = X(1+(i-1)*30:10+(i-1)*30, :);
        LTemp = L(1+(i-1)*30:10+(i-1)*30, :);
        XTrain = [XTrain; XTemp];
        LabelTrain = [LabelTrain; LTemp];
        XTemp = X(11+(i-1)*30:30+(i-1)*30, :);
        LTemp = L(11+(i-1)*30:30+(i-1)*30, :);
        XTest = [XTest; XTemp];
        LabelTest = [LabelTest; LTemp];
    end
    Label_SVM_Train = [[ones(10,1); -ones(30,1)], [-ones(10,1); ones(10,1); -ones(20,1)]...
        [-ones(20,1); ones(10,1); -ones(10,1)], [-ones(30,1); ones(10,1)]]; %OVR label
    % Train the SVM Classifier
    for i = 1:4
        switch i
            case 1
                SVM_Model_1 = fitcsvm(XTrain,Label_SVM_Train(:,i),'KernelFunction','rbf','Standardize',false,'ClassNames',[-1,1]);
            case 2
                SVM_Model_2 = fitcsvm(XTrain,Label_SVM_Train(:,i),'KernelFunction','rbf','Standardize',false,'ClassNames',[-1,1]);
            case 3
                SVM_Model_3 = fitcsvm(XTrain,Label_SVM_Train(:,i),'KernelFunction','rbf','Standardize',false,'ClassNames',[-1,1]);
            case 4
                SVM_Model_4 = fitcsvm(XTrain,Label_SVM_Train(:,i),'KernelFunction','rbf','Standardize',false,'ClassNames',[-1,1]);
        end
    end
    % Predict scores and determin labels
    [~,score1] = predict(SVM_Model_1,XTest);
    [~,score2] = predict(SVM_Model_2,XTest);
    [~,score3] = predict(SVM_Model_3,XTest);
    [~,score4] = predict(SVM_Model_4,XTest);
    score = [score1(:,2), score2(:,2), score3(:,2), score4(:,2)];
    for i = 1:size(score,1) %highest classifiers get the label
        LabelTestSVM(i,1) = find(score(i,:) == max(score(i,:)));
    end
    % calculate CM
    for i = 1:4
        for k = 1:20
            switch LabelTestSVM((i-1)*20+k)
                case 1
                    CM(1,i) = CM(1,i)+1;
                case 2
                    CM(2,i) = CM(2,i)+1;
                case 3
                    CM(3,i) = CM(3,i)+1;
                case 4
                    CM(4,i) = CM(4,i)+1;
            end
        end
    end
    % calculate accuracies
    Ac = LabelTestSVM - LabelTest;
    for i = 1:size(Ac)
        if Ac(i) ~= 0
            Ac(i) = 1;
        end
    end
    AcR1 = 1-sum(Ac(1:20))/20;
    AcR2 = 1-sum(Ac(21:40))/20;
    AcR3 = 1-sum(Ac(41:60))/20;
    AcR4 = 1-sum(Ac(61:80))/20;
    AcR1Sum = AcR1Sum+AcR1;
    AcR2Sum = AcR2Sum+AcR2;
    AcR3Sum = AcR3Sum+AcR3;
    AcR4Sum = AcR4Sum+AcR4;
end
AcR1Sum = AcR1Sum/n_test;
AcR2Sum = AcR2Sum/n_test;
AcR3Sum = AcR3Sum/n_test;
AcR4Sum = AcR4Sum/n_test;
CM = CM/n_test/20;

% draw the confusion matric
ConfMatPlot(CM,'labelname',LabelName);

end