close all
clear,clc;
%% 数据初始化
% 此处数据需手动输入或修改
month=200;
Fox_immature(1)=400;
Fox_mature(1)=70;
Rodent_immature(1)=50000;
Rodent_mature(1)=12000;

%% 迭代开始
Starve_record(1)=0;
for m=2:month
    %% 水草是否满足啮齿动物食物需求
    if Rodent_immature(m-1)+Rodent_mature(m-1)>100000
        Rodent_immature_starve(m-1)=Rodent_immature(m-1)/3;
        Rodent_mature_starve(m-1)=Rodent_immature(m-1)/3;
    else
        Rodent_immature_starve(m-1)=0;
        Rodent_mature_starve(m-1)=0;
    end
    %% 计算啮齿动物数量
    Rodent_immature_add(m-1)=Rodent_mature(m-1)*0.8;
    Rodent_immature_hunted(m-1)=(Fox_immature(m-1) *10+Fox_mature(m-1) *60) *Rodent_immature(m-1) / (Rodent_immature(m-1)+Rodent_mature(m-1) ) ;
    Rodent_mature_hunted(m-1)=(Fox_immature(m-1) *10+Fox_mature(m-1) *60) *Rodent_mature(m-1) / (Rodent_immature(m-1)+Rodent_mature(m-1) ) ;
    Rodent_immature_orphan(m-1)=Rodent_mature_hunted(m-1) *1.8;
    if m<=3
        Rodent_immature_grow(m)=0;
    else
        Rodent_immature_grow(m-3)=Rodent_immature_add(m-3) ;
        for n=1:3
            Rodent_immature_grow(m+n-3)=Rodent_immature_grow(m+n-4)-(Rodent_immature_hunted(m+n-4)+Rodent_immature_orphan(m+n-4)+Rodent_immature_starve(m+n-4) ) *Rodent_immature_grow(m+n-4) /Rodent_immature(m+n-4) ;
        end
    end
    %% 计算啮齿动物数量
    % 第m月幼年啮齿动物数量
    Rodent_immature(m)=Rodent_immature(m-1)+Rodent_immature_add(m-1)-Rodent_immature_hunted(m-1)-Rodent_immature_orphan(m-1)-Rodent_immature_grow(m)-Rodent_immature_starve(m-1) ;
    % 第m月成年啮齿动物数量
    Rodent_mature(m)=Rodent_mature(m-1)+Rodent_immature_grow(m)-Rodent_mature_hunted(m-1)-Rodent_mature_starve(m-1) ;
    %% 计算狐狸数量
    % 计算狐狸的总数量
    if Fox_immature(m-1) *10+Fox_mature(m-1) *60 >=Rodent_immature(m-1)+Rodent_mature(m-1) || Fox_mature(m-1)<0
        % 系统发生崩溃
        fprintf('系统发生崩溃');
        break;
    elseif Fox_immature(m-1) *10+Fox_mature(m-1) *60 >=(Rodent_immature(m-1)+Rodent_mature(m-1) ) /20
        % 记录狐狸出现的饿死情况
        Starve_record(m)=1;
        Fox_immature_starve(m-1)=Fox_immature(m-1)/3;
        Fox_mature_starve(m-1)=Fox_mature(m-1)/3;
    else
        Starve_record(m)=0;
        Fox_immature_starve(m-1)=0;
        Fox_mature_starve(m-1)=0;
    end
    if m<=8
        Fox_immature_grow(m)=0;
    else
        Starvation=0;
        for i=m-8:m-1
            Starvation=Starvation+Starve_record(i) ;
        end
        Fox_immature_grow(m)=Fox_immature_add(m-8) * (2/3) ^Starvation;
    end
    %% 在10年后猎人加入系统，进行对狐狸的捕杀
    if m<=120
        Fox_killed=0;
    else
        Fox_killed=4;
    end
    %% 狐狸的出生
    Fox_immature_add(m-1)=Fox_mature(m-1)*4;
    Fox_immature(m)=Fox_immature(m-1)+Fox_immature_add(m-1)-Fox_immature_starve(m-1)-Fox_immature_grow(m) ;
    Fox_mature(m)=Fox_mature(m-1)+Fox_immature_grow(m)-Fox_mature_starve(m-1)-Fox_killed;
end
%% 绘制系统内种群数量变化图
figure, plot(Fox_immature,'LineWidth',1.5) , axis ( [0,month,0, 1000] ) , title( '幼年狐狸' ) ,xlabel( '月份' ) ,ylabel( '数量' ) ;
figure, plot(Fox_mature,'LineWidth',1.5) , axis ( [0,month,0, 150] ) , title( '成年狐狸' ),xlabel( '月份' ) ,ylabel( '数量' ) ;
figure, plot(Fox_mature+Fox_immature,'LineWidth',1.5) , axis ( [0,month,0,1000] ) ,title( '狐狸总数量' ) ,xlabel( '月份' ) ,ylabel( '数量' );
figure, plot(Rodent_immature,'LineWidth',1.5) , axis ( [0,month,0,80000] ) , title( '幼年啮齿动物' ) ,xlabel( '月份' ) ,ylabel( '数量' ) ;
figure, plot(Rodent_mature,'LineWidth',1.5) , axis ( [0,month,0,50000] ) , title( '成年啮齿动物' ) ,xlabel( '月份' ),ylabel( '数量' ) ;
figure, plot(Rodent_mature+Rodent_immature,'LineWidth',1.5) ,axis ( [0,month,0,150000] ) , title( '啮齿动物总数量' ) ,xlabel( '月份' ),ylabel( '数量' ) ;