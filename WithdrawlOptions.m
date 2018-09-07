function [WOrder] = WithdrawlOptions(ClassesReturns, WithdrawlOrder, DrainOrderBuckets, DefaultClass)

if  WithdrawlOrder == 1
    
    BestRank = zeros( size(ClassesReturns,1),size(ClassesReturns,2) );
    for i = 1 : size(ClassesReturns,1)
        for j = 1 : size(ClassesReturns,2)
            Comparison = (ClassesReturns(i,j) > ClassesReturns(i,:));
            for k = 0: size(ClassesReturns,2)-1
                if sum(Comparison) == k
                    BestRank(i,j) = size(ClassesReturns,2) - k ;
                end
            end
        end
    end
    WOrder = BestRank;
    
elseif  WithdrawlOrder == 2
    
     WorstRank = zeros( size(ClassesReturns,1),size(ClassesReturns,2) );
     for i = 1 : size(ClassesReturns,1)
        for j = 1 : size(ClassesReturns,2)
            Comparison = (ClassesReturns(i,j) < ClassesReturns(i,:));
            for k = 0: size(ClassesReturns,2)-1
                if sum(Comparison) == k
                    WorstRank(i,j) = size(ClassesReturns,2) - k ;
                end
            end
        end
     end
     WOrder = WorstRank;
     
elseif  WithdrawlOrder == 4
    
    DefaultDrainClass = DrainOrderBuckets(DefaultClass);
    CheckClassesIndex = 1 : DefaultDrainClass-1;
    DrainOrder = zeros( size(ClassesReturns,1),size(ClassesReturns,2) );
    
    for i = 1 : size(ClassesReturns,1)
        DrainOrder(i,:) = DrainOrderBuckets;
        count = 0;
        for j = CheckClassesIndex
            if  ClassesReturns(i, sum((1:size(ClassesReturns,2)).*(DrainOrder(i,:) == j-count))) < 0 
                DrainOrder(i,sum((1:size(ClassesReturns,2)).*(DrainOrder(i,:) == j-count))) = max(DrainOrder(i,:)) + 1;
                for k = j+1-count: max(DrainOrder(i,:))
                    DrainOrder(i,sum((1:size(ClassesReturns,2)).*(DrainOrder(i,:) == k))) = DrainOrder(i,sum((1:size(ClassesReturns,2)).*(DrainOrder(i,:) == k))) - 1;
                end
                count = count +1;
            else 
                DrainOrder(i,sum((1:size(ClassesReturns,2)).*(DrainOrder(i,:) == j-count))) = DrainOrder(i,sum((1:size(ClassesReturns,2)).*(DrainOrder(i,:) == j-count)));    
            end
        end
    end
    
    WOrder = DrainOrder;
  
elseif  WithdrawlOrder == 0
    
     WOrder = ones(size(ClassesReturns,1),size(ClassesReturns,2)); 
     
end
     
     
end