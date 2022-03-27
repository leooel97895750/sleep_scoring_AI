function [output] =sp(result_final)
% result_final=fitness;
%%Specificity
spec=zeros(1,5);
ppv=zeros(1,5);
bbb=zeros(5,1);
table=zeros(5,5);
result_final=[result_final bbb]
result_final(1,6)=sum(result_final(1,:));
result_final(2,6)=sum(result_final(2,:));
result_final(3,6)=sum(result_final(3,:));
result_final(4,6)=sum(result_final(4,:));
result_final(5,6)=sum(result_final(5,:));
total=sum(result_final(:,6));
table(1:5,1:5)=result_final(1:5,1:5);
spec(1,1)=(total-sum(table(1,:))-sum(table(:,1))+table(1,1))/sum(result_final(2:5,6));
spec(1,2)=(total-sum(table(2,:))-sum(table(:,2))+table(2,2))/(sum(result_final(3:5,6))+result_final(1,6));
spec(1,3)=(total-sum(table(3,:))-sum(table(:,3))+table(3,3))/(sum(result_final(4:5,6))+sum(result_final(1:2,6)));
spec(1,4)=(total-sum(table(4,:))-sum(table(:,4))+table(4,4))/(sum(result_final(1:3,6))+result_final(5,6));
spec(1,5)=(total-sum(table(5,:))-sum(table(:,5))+table(5,5))/sum(result_final(1:4,6));

ppv(1,1)=table(1,1)/sum(table(:,1));
ppv(1,2)=table(2,2)/sum(table(:,2));
ppv(1,3)=table(3,3)/sum(table(:,3));
ppv(1,4)=table(4,4)/sum(table(:,4));
ppv(1,5)=table(5,5)/sum(table(:,5));

output=[spec ppv];