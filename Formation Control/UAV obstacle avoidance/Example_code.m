
clc;close all;clear all
dbstop if error



%---制作动画标志
 % frame=1;
 % cartoon=1;%为1时制作视频，仿真较慢。

%% 参数及初始化

N=15;%Follower个数
M=3;%障碍物个数
d=15;%势能函数参数（期望距离？）
r=15;%通信距离
c1b=0.1;%potential function 权重
c1g=0.1;%gamma的距离项权重
c2b=2*sqrt(c1b); %速度项权重
c2g=sqrt(c1g); %gamma的速度项权重
K=1.4;%势能函数参数
dt=0.01;%步长
step=2500;
pos=25*(rand(N,3)-0.5);%初始位置
V=rand(N,3);

%% 始赋值，减少仿真时间
posg=[0 0 0];%Leader位置;
Vg=[10 0 0];%Leader速度

Obs=[160 0 0;%目标位置
    120 -5 10;
    80 10 -5];
Obsr=[7;9;8];%%障碍物半径


timm=zeros(step,1);
Di=zeros(N,step);
D_O=zeros(N*M,step);
DD=zeros(step,1);
D_Om=zeros(step,1);
u=zeros(N,3,step);
du=zeros(N,step);
xx=zeros(N,step);
yy=zeros(N,step);
zz=zeros(N,step);
xg=zeros(N,step);
yg=zeros(N,step);
zg=zeros(N,step);
v=zeros(N,step);



%---做视频----
% writerObj=VideoWriter('Flocking3.1');
% open(writerObj);

for t=1:step
    k=0;
    kk=0;
    timm(t)=dt*t;
    
%% 遍历每个agent  
    for i=1:N 
        u1=[0 0 0];
        u2=[0 0 0];
%% 遍历alpha-agents        
        for j=1:N %%找无人机i的邻居
            if i==j
                continue
            end %遍历到自己时跳过
            del_q=norm(pos(j,:)-pos(i,:));%%两个无人机之间的距离
            k=k+1;
            Di(k,t)=del_q; % 记录alpha-agents里面i和其他无人机的距离
            x=del_q;  
            if del_q<r %%两架无人机之间的距离小于通信距离
                fai=-K*(x-d)*(x-r)*(pos(i,:)-pos(j,:))/x*(d+r-x);%%势能函数
                u1=u1+fai;%%式3.20第一项
                sij=(pos(i,:)-pos(j,:))/x+0*(x==0);%（1）i和j之间的单位法线向量。（2）0*（x==0）产生和x同维数的零矩阵，防止x=0时出现无解
                pij=V(i,:)-sij*sij'*V(i,:)+sij*sij'*Vg;     %%式3.17， alpha-agnts被当作beta重新定义的速度
                u2=u2+(V(i,:)-pij);    %%式3.20第二项，和论文里的第二项符号相反
            end
        end
%% 遍历beta-agents         
        for m=1:M %%障碍物
            D_io=norm(pos(i,:)-Obs(m,:));%%第i个无人机和当前障碍物m圆心的距离
            kk=kk+1;
            D_O(kk,t)=D_io-Obsr(m);%%第i个无人机到当前障碍物m边缘的距离
            if D_io<=(Obsr(m)+r)%%无人机和距障碍物圆心距离小于通信距离时
                c=pos(i,:)+(Obs(m,:)-pos(i,:))*(D_io-Obsr(m))/D_io;%%障碍物边缘的位置向量
                del_q_ib=norm(pos(i,:)-c);%%此处表示无人机和当前障碍物m边缘的距离
                y=del_q_ib;%%无人机和当前障碍物m边缘的距离
                fai=-K*2*(y-d)*(y-r)*(pos(i,:)-c)/y*(d+r-y);%%势能函数
                u1=u1+fai;%%式3.20第一项
                sij=(pos(i,:)-c)/del_q_ib+0*(del_q_ib==0);%单位向量
                pij=V(i,:)-sij*sij'*V(i,:)+sij*sij'*Vg;
                u2=u2+(V(i,:)-pij);%%式3.20第二项
            end
        end
%% 遍历sigmma-agents        
        ubeta=-c1b*u1-c2b*u2;%%式3.20
        del_q_ig=pos(i,:)-posg;%%当前无人机i与虚拟领航者的距离之差（向量）
        ugamma=-c2g*10*(V(i,:)-Vg)-c1g*del_q_ig*(norm(del_q_ig));%%式3.24
        u(i,:,t)=ubeta+ugamma;%%式3.19
        du(i,t)=norm(u(i,:,t));%%在t时刻，无人机i的控制量（加速度）的大小
%                 if du(i,t)>100
%                     u(i,1:3,t)=10*u(i,1:3,t)/du(i,t);
%                 end
        V(i,:)=V(i,:)+u(i,:,t)*dt;%%式3.8
        pos(i,:)=pos(i,:)+V(i,:)*dt;%%式3.8
        
        xx(i,t)=pos(i,1);%%在t时刻，无人机i在x轴位置
        yy(i,t)=pos(i,3);%%在t时刻，无人机i在z轴的位置，但放在yy，因为plot3画图顺序
        zz(i,t)=pos(i,2);%%在t时刻，无人机i在y轴的位置
        v(i,t)=norm(V(i,:));%%在t时刻，无人机i速度大小
    end
    
%% 记录距离数据和更新leader的position    
    D_Om(t)=min(D_O(:,t));%%在t时刻，所有无人机与障碍物边缘（是否会撞上）的距离中最小的那个距离
    DD(t)=min(Di(:,t));%aplha agents 之间最短距离
    
    %Leader 运动------比例导引
    posg=posg+Vg*dt;
    xg(t)=posg(1);
    yg(t)=posg(2);
    zg(t)=posg(3);
    
    
    %----画图部分
        % if rem(t,10)==0%%为了使画图动画快些，不在每个t都画图
        %     figure(1)
        %     plot3(pos(1,1),pos(1,3),pos(1,2),'bo');
        %     hold on
        %     plot3(posg(1,1),posg(1,3),posg(1,2),'go');
        %     for i=1:N
        %         plot3(pos(i,1),pos(i,3),pos(i,2),'bo');
        %         for j=1:N
        %             if i==j
        %                 continue
        %             else
        %                 if norm(pos(i,:)-pos(j,:))<r
        %                     plot3([pos(i,1) pos(j,1)],[pos(i,3) pos(j,3)],[pos(i,2) pos(j,2)],'r--');
        %                 end
        %             end
        %         end
        %     end
        %     [x,y,z]=sphere;
        %     for i=1:M
        %         mesh(Obsr(i)*x+Obs(i,1),Obsr(i)*y+Obs(i,3),Obsr(i)*z+Obs(i,2));
        %         hold on
        %     end
        %     quiver3(pos(:,1),pos(:,3),pos(:,2),V(:,1),V(:,3),V(:,2),0.3,'LineWidth',1.5)
        %     quiver3(posg(:,1),posg(:,3),posg(:,2),Vg(:,1),Vg(:,3),Vg(:,2),0.3,'LineWidth',1.5)
        % 
        %     legend({'\itUAV','\itLeader'},'Location','NorthEast','Fontsize',15);
        %     axis equal
        %     grid on
        %     xlabel('X','Fontsize',20);
        %     ylabel('Z','Fontsize',20);
        %     zlabel('Y','Fontsize',20);
        %     h=gca;
        %     set(h,'Fontsize',18)
        %     hold off
        % 
        %     if cartoon==1
        %         frame=getframe;
        %         frame.cdata=imresize(frame.cdata,[400 550]);
        %         writeVideo(writerObj,frame);
        %     end
        % 
        % end%%为了让画图动画快点
        
end
 %close(writerObj);

%% Figure2
figure(2)
plot3(xx(1,2000),yy(1,2000),zz(1,2000),'o');
hold on
plot3(xg(2000),yg(2000),zg(2000),'ro','MarkerFaceColor','r');
for i=1:N
    plot3(xx(i,1:2000),yy(i,1:2000),zz(i,1:2000),':','LineWidth',0.8);
    plot3(xx(i,1),yy(i,1),zz(i,1),'o','MarkerFaceColor','b');
%     plot3(xx(i,500),yy(i,500),zz(i,500),'ro','MarkerFaceColor','r');
    plot3(xx(i,1000),yy(i,1000),zz(i,1000),'go','MarkerFaceColor','g');
    plot3(xx(i,1500),yy(i,1500),zz(i,1500),'mo','MarkerFaceColor','m');
    plot3(xx(i,2000),yy(i,2000),zz(i,2000),'o','MarkerFaceColor','k');
end
plot3(xg(1:2000),yg(1:2000),zg(1:2000),'r--','LineWidth',1.2);
[x,y,z]=sphere;
for i=1:M
    mesh(Obsr(i)*x+Obs(i,1),Obsr(i)*y+Obs(i,3),Obsr(i)*z+Obs(i,2));
    hold on
end
legend({'\itUAV','\itLeader'},'Location','NorthEast','Fontsize',15);
axis equal
xlabel('X','Fontsize',20);
ylabel('Z','Fontsize',20);
zlabel('Y','Fontsize',20);
h=gca;
set(h,'Fontsize',18)

%% Figure3
figure(3)
plot(timm,DD,'r--','LineWidth',1.5);
xlabel('{\itt}/s','Fontsize',18);ylabel('||{\itq_i_j}||/m','Fontsize',15,'Rotation',90);
h=gca;
set(h,'Fontsize',18)
% if cartoon==1
%     mpgwrite(MM,colormap,'Flocking1')
% end

%% Figure4
figure(4)
for i=1:N
    plot(timm,v,'b--','LineWidth',1.5)
end
xlabel('{\itt}/s','Fontsize',18);ylabel('{\itV_i}/m,i=1,...,15','Fontsize',15,'Rotation',90);
h=gca;
set(h,'Fontsize',18)

%% Figure5
figure(5)
plot(timm,D_Om,'b--','LineWidth',1.5);
xlabel('{\itt}/s','Fontsize',18);ylabel('{\itDistance}/m','Fontsize',15,'Rotation',90);
h=gca;
set(h,'Fontsize',18)