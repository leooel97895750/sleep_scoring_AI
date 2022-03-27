function [autostage nodestage] = run_purposed_chun(data,feat)

    result_table = zeros(5,5);
    totalruletable = zeros(15,6);
    result_before = zeros(5,5);
    
    final_table=[];


    [autostage nodestage] = multi_scale_auto_staging_Siesta_chun(data,feat);
%     totalruletable = ruletable + totalruletable;
%     result_table = result_table + table;
%     table11={table};
%     table12={sp(table)};
%     result_before = result_before + table2;
% 
%     final_table(1:5,1:5)=result_table;
%     final_table(1,6)=result_table(1,1)/sum(result_table(1,:))*100 ;
%     final_table(2,6)=result_table(2,2)/sum(result_table(2,:))*100 ;
%     final_table(3,6)=result_table(3,3)/sum(result_table(3,:))*100 ;
%     final_table(4,6)=result_table(4,4)/sum(result_table(4,:))*100 ;
%     final_table(5,6)=result_table(5,5)/sum(result_table(5,:))*100 ;
%     final_table(6,6)=(result_table(1,1)+result_table(2,2)+result_table(3,3)+result_table(4,4)+result_table(5,5))/...
%         (sum(result_table(:,1))+sum(result_table(