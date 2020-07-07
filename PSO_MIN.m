syms a b
j=a^2+b^2;
ezmesh(a,b,a^2+b^2,[-10,11,-10,11]);
hold on
%% idea:
% 核心是迭代，没有必要矩阵运算。矩阵只是作为信息储存！
% 关于局部最优解，个人理解初始种群足够大、足够随机也可以减少限制在局部最优解的几率
% https://wenku.baidu.com/view/65c600b9294ac850ad02de80d4d8d15abe230048.html
N=10;
D=2;
%% 初始化：位置与速度
% v (速度) 并不储存历史信息，储存值为当前速度
% x (位置) 储存历史信息
% N (粒子个数)
% D (空间维数)
format long;
xlimit = [-10, 11;-10,11]; %位置限制 维数为行！！*******！！位置的维数为列
vlimit = [-1, 1;-1,1]; %速度限制 维数为行！！*******！！速度的维数为列
x=zeros(N,D);
v=zeros(N,D);
for d = 1:D %一次初始一维，因为维度限制不一样
    x(:,d) = xlimit(d, 1) + (xlimit(d, 2) - xlimit(d, 1)) * rand(N,1);% rand函数产生由在(0, 1)之间均匀分布的随机数组成的数组。
    v(:,d) = vlimit(d, 1) + (vlimit(d, 2) - vlimit(d, 1)) * rand(N,1);
end
%% 计算：粒子适应度 & 初始化：个体最优解与全局最优解
% pbest = personalbest (个人最优解) 
% gbest = globlebest (全局最优解)
% fitness (目标函数)
for i = 1:N
    f(i) = fitness(x(i,:));%适应值 储存值为当前值
    pbest(i,:) = x(i,:);
end
[value,row]=min(f);
gbest = x(row,:);
%  plot(gbest(1),fitness(gbest),'ro');
 plot3(gbest(1),gbest(2),fitness(gbest),'ro');
%% 主要循环，依次迭代，直到满足精度要求
% w (惯性权重) 越大全局强，越小局部强，体现扩展空间的特性 <一般取[0,1]>
% c1 (个人学习能力) 体现个人最优解的影响能力 <一般取2>
% c2 (社会学习能力) 体现全局最优解的影响能力 <一般取2>
% M (最大迭代次数)
w=0.729;
c1=2;
c2=2;
M=1000;
count=0;%当坐标长时间小范围变化就跳出迭代
for t = 1:M % 管理迭代次数
    for i = 1:N % 依次更新一个粒子的所有维度
        v(i,:) = w*v(i,:)+c1*rand*(pbest(i,:)-x(i,:))+c2*rand*(gbest-x(i,:));
        % 边界速度处理
        for d = 1:D % 一个粒子的不同维度依次分别与限制比较
            if v(i,d) > vlimit(d,2)
               v(i,d) = vlimit(d,2);
            end
            if v(i,d) < vlimit(d,1)
               v(i,d)= vlimit(d,1);
            end
        end
        x(i,:) = x(i,:)+v(i,:);
        %位置越界处理
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
            %精度控制
            if abs(f(i)-fitness(gbest))<1e-3
                count=count+1;
            end
            gbest = pbest(i,:)          
%             plot(gbest,fitness(gbest),'ro');
             plot3(gbest(1),gbest(2),fitness(gbest),'ro');
            hold on
            pause(0.5) %每隔0.5s画个点方便观察实际效果
        end
    end
    if count >10 
        break;
    end
    fbest(t) = fitness(gbest); 
end
% plot(gbest,fitness(gbest),'go');
 plot3(gbest(1),gbest(2),fitness(gbest),'go');
