clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=10;     %Ni �ڵ���Ŀ
%W     %W(i,j) �ڵ�i�ڽ���jִ�е�ͨ�Ż���
%C     %Cij �ڵ�i��j��ͨ�Ż���
%P     %Pi ���̵ļ���;
N_p=3;  %���̵���Ŀ
n_enter=1;
n_exit=10;
C=zeros(N,N);

%���������ͼ
C(1,2)=18;
C(1,3)=12;
C(1,4)=9;
C(1,5)=11;
C(1,6)=14;
C(2,8)=19;
C(2,9)=16;
C(3,7)=23;
C(4,8)=27;
C(4,9)=23;
C(5,9)=13;
C(6,8)=15;
C(7,10)=17;
C(8,10)=11;
C(9,10)=13;

W(1,1)=14;
W(1,2)=16;
W(1,3)=9;
W(2,1)=13;
W(2,2)=19;
W(2,3)=18;
W(3,1)=11;
W(3,2)=13;
W(3,3)=19;
W(4,1)=13;
W(4,2)=8;
W(4,3)=17;
W(5,1)=12;
W(5,2)=13;
W(5,3)=10;
W(6,1)=13;
W(6,2)=16;
W(6,3)=9;
W(7,1)=7;
W(7,2)=15;
W(7,3)=11;
W(8,1)=5;
W(8,2)=11;
W(8,3)=14;
W(9,1)=18;
W(9,2)=12;
W(9,3)=20;
W(10,1)=21;
W(10,2)=7;
W(10,3)=16;
%��������DAG
 draw_graph(C);
 for i=1:1:N
     W_ave(i)=sum(W(i,:))/N_p;
 end
 W_ave=W_ave';
 
 
 %��exit�ڵ㿪ʼ����ranku
 ranku(N)=W_ave(N);
 for i=N-1:-1:1
     %���ҽڵ�i����һ���ڵ�,next����һ���ڵ�ļ���
     next=find(C(i,:)~=0);
     %temp=C(i,:)+ranku([next]);
     [num1,num2]=size(next);
     for m=1:1:num2
         temp(m)=C(i,next(m))+ranku(next(m));
     end
     max_num=max(temp);
     ranku(i)=W_ave(i)+max_num;
     ranku(i)=roundn(ranku(i),-3);%����С�������λ
 end
 
 %��enter�ڵ㿪ʼ����rankd
 rankd(1)=0;
 for i=2:1:N
     pre=find(C(:,i)~=0);
     %pre�ǽڵ�i���ȵ�����
     [num1,num2]=size(pre);
     for m=1:1:num1;
        temp1(m)=rankd(pre(m))+C(pre(m),i)+W_ave(pre(m));
     end
     max_num=max(temp1);
     rankd(i)=max_num;
     rankd(i)=roundn(rankd(i),-3);
 end
 
 priority=rankd+ranku;
 priority=roundn(priority,-3);
 priority(n_exit)=round(priority(n_exit));
 %�������У�priorΪ���ȼ��Ӹߵ��͵Ľڵ㡣
 %[result,prior]=sort(rank,'descend');
 
 
 %SETcp��Źؼ�·���ϵĽڵ�
 SETcp=[n_enter];
 CP=priority(n_enter);
 n_k=n_enter;%
 while n_k~=n_exit
    n_son=find(C(n_k,:)~=0);%��ǰ�ڵ���ӽڵ�
    [num1,num2]=size(n_son);
    for q=1:1:num2
        if priority(n_son(q))==CP
            n_j=n_son(q);
            break;
        end
    end
    n_k=n_j;
    SETcp=[SETcp,n_k];
 end
 
 
 %��ÿһ�����̣�����Wij����Сֵ���ڵ�i����SETcp
 for p=1:1:N_p
    [num1,num2]=size(SETcp);
    w_temp(p)=0;
    for n=1:1:num2
        w_temp(p)=w_temp(p)+W(SETcp(n),p);
    end
 end
p_cp=find(min(w_temp)==w_temp);
%p_cp�ǹؼ�·����Сcost�Ľ���
 

%�����task�������е����ȼ�����
task=[1,2,3,7,4,5,9,6,8,10];
for i=1:1:N_p
    EST(task(1),i)=0;
    EFT(task(1),i)=EST(task(1),i)+W(task(1),i);
end
    EST_true(1)=EST(task(1),p_cp);
    EFT_true(1)=EFT(task(1),p_cp);
    process(p_cp).member=task(1);
    now(p_cp)=task(1);
    now(1)=0;
    now(3)=0;
    node_inprocess(task(1))=p_cp;
    process(1).member=[];
    process(3).member=[];
for i=2:1:N
    father=find(C(:,task(i))~=0);%�ýڵ�ĸ��ڵ�
    [num_father,temp]=size(father);
     for m=1:1:N_p
        
        for k=1:1:num_father
            if m==node_inprocess(father(k))
                temp(m,k)=EFT_true(father(k))
            else
                temp(m,k)=EFT_true(father(k))+C(father(k),task(i));
            end
        end
         if now(m)==0
            EST(task(i),m)=max(temp(m,:));
            EFT(task(i),m)=EST(task(i),m)+W(task(i),m);
        else
            EST(task(i),m)=max([EFT_true(now(m)),max(temp(m,:))]);
            EFT(task(i),m)=EST(task(i),m)+W(task(i),m);
         end       
     end
	if ismember(task(i),SETcp)==1    %����ڵ����ڹؼ�·��
        now(p_cp)=task(i);
        process(p_cp).member=[process(p_cp).member,task(i)];
        node_inprocess(task(i))=p_cp;
        EFT_true(task(i))=EFT(task(i),p_cp);
	else  %�ڵ㲻���ڹؼ��ڵ㣬ͨ��Ѱ����СEFT
        EFT_true(task(i))=min(EFT(task(i),:));
        temp2=find(min(EFT(task(i),:))==EFT(task(i),:));%�ҵ������ڵĽ���
        node_inprocess(task(i))=temp2(1);
        now(node_inprocess(task(i)))=task(i);
        process(node_inprocess(task(i))).member=[process(node_inprocess(task(i))).member,task(i)];%ĳ�����̵����е�����
	end
end

 
 
 
 
 