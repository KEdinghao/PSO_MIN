syms a b
j=a^2+b^2;
ezmesh(a,b,a^2+b^2,[-10,11,-10,11]);
hold on
%% idea:
% �����ǵ�����û�б�Ҫ�������㡣����ֻ����Ϊ��Ϣ���棡
% ���ھֲ����Ž⣬��������ʼ��Ⱥ�㹻���㹻���Ҳ���Լ��������ھֲ����Ž�ļ���
% https://wenku.baidu.com/view/65c600b9294ac850ad02de80d4d8d15abe230048.html
N=10;
D=2;
%% ��ʼ����λ�����ٶ�
% v (�ٶ�) ����������ʷ��Ϣ������ֵΪ��ǰ�ٶ�
% x (λ��) ������ʷ��Ϣ
% N (���Ӹ���)
% D (�ռ�ά��)
format long;
xlimit = [-10, 11;-10,11]; %λ������ ά��Ϊ�У���*******����λ�õ�ά��Ϊ��
vlimit = [-1, 1;-1,1]; %�ٶ����� ά��Ϊ�У���*******�����ٶȵ�ά��Ϊ��
x=zeros(N,D);
v=zeros(N,D);
for d = 1:D %һ�γ�ʼһά����Ϊά�����Ʋ�һ��
    x(:,d) = xlimit(d, 1) + (xlimit(d, 2) - xlimit(d, 1)) * rand(N,1);% rand������������(0, 1)֮����ȷֲ����������ɵ����顣
    v(:,d) = vlimit(d, 1) + (vlimit(d, 2) - vlimit(d, 1)) * rand(N,1);
end
%% ���㣺������Ӧ�� & ��ʼ�����������Ž���ȫ�����Ž�
% pbest = personalbest (�������Ž�) 
% gbest = globlebest (ȫ�����Ž�)
% fitness (Ŀ�꺯��)
for i = 1:N
    f(i) = fitness(x(i,:));%��Ӧֵ ����ֵΪ��ǰֵ
    pbest(i,:) = x(i,:);
end
[value,row]=min(f);
gbest = x(row,:);
%  plot(gbest(1),fitness(gbest),'ro');
 plot3(gbest(1),gbest(2),fitness(gbest),'ro');
%% ��Ҫѭ�������ε�����ֱ�����㾫��Ҫ��
% w (����Ȩ��) Խ��ȫ��ǿ��ԽС�ֲ�ǿ��������չ�ռ������ <һ��ȡ[0,1]>
% c1 (����ѧϰ����) ���ָ������Ž��Ӱ������ <һ��ȡ2>
% c2 (���ѧϰ����) ����ȫ�����Ž��Ӱ������ <һ��ȡ2>
% M (����������)
w=0.729;
c1=2;
c2=2;
M=1000;
count=0;%�����곤ʱ��С��Χ�仯����������
for t = 1:M % �����������
    for i = 1:N % ���θ���һ�����ӵ�����ά��
        v(i,:) = w*v(i,:)+c1*rand*(pbest(i,:)-x(i,:))+c2*rand*(gbest-x(i,:));
        % �߽��ٶȴ���
        for d = 1:D % һ�����ӵĲ�ͬά�����ηֱ������ƱȽ�
            if v(i,d) > vlimit(d,2)
               v(i,d) = vlimit(d,2);
            end
            if v(i,d) < vlimit(d,1)
               v(i,d)= vlimit(d,1);
            end
        end
        x(i,:) = x(i,:)+v(i,:);
        %λ��Խ�紦��
        for d = 1:D
            if x(i,d) > xlimit(d,2)  
               x(i,d) = xlimit(d,2);
            end
            if x(i,d) < xlimit(d,1)
               x(i,d) = xlimit(d,1);
            end
        end
        if fitness(x(i,:)) < f(i)
            f(i) = fitness(x(i,:));
            pbest(i,:) = x(i,:);
        end
        if f(i) < fitness(gbest)
            %���ȿ���
            if abs(f(i)-fitness(gbest))<1e-3
                count=count+1;
            end
            gbest = pbest(i,:)          
%             plot(gbest,fitness(gbest),'ro');
             plot3(gbest(1),gbest(2),fitness(gbest),'ro');
            hold on
            pause(0.5)
        end
    end
    if count >10 
        break;
    end
    fbest(t) = fitness(gbest); 
end
% plot(gbest,fitness(gbest),'go');
 plot3(gbest(1),gbest(2),fitness(gbest),'go');
