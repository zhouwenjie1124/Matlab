
clc;close all;clear all
dbstop if error



%---����������־
 % frame=1;
 % cartoon=1;%Ϊ1ʱ������Ƶ�����������

%% ��������ʼ��

N=15;%Follower����
M=3;%�ϰ������
d=15;%���ܺ����������������룿��
r=15;%ͨ�ž���
c1b=0.1;%potential function Ȩ��
c1g=0.1;%gamma�ľ�����Ȩ��
c2b=2*sqrt(c1b); %�ٶ���Ȩ��
c2g=sqrt(c1g); %gamma���ٶ���Ȩ��
K=1.4;%���ܺ�������
dt=0.01;%����
step=2500;
pos=25*(rand(N,3)-0.5);%��ʼλ��
V=rand(N,3);

%% ʼ��ֵ�����ٷ���ʱ��
posg=[0 0 0];%Leaderλ��;
Vg=[10 0 0];%Leader�ٶ�

Obs=[160 0 0;%Ŀ��λ��
    120 -5 10;
    80 10 -5];
Obsr=[7;9;8];%%�ϰ���뾶


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



%---����Ƶ----
% writerObj=VideoWriter('Flocking3.1');
% open(writerObj);

for t=1:step
    k=0;
    kk=0;
    timm(t)=dt*t;
    
%% ����ÿ��agent  
    for i=1:N 
        u1=[0 0 0];
        u2=[0 0 0];
%% ����alpha-agents        
        for j=1:N %%�����˻�i���ھ�
            if i==j
                continue
            end %�������Լ�ʱ����
            del_q=norm(pos(j,:)-pos(i,:));%%�������˻�֮��ľ���
            k=k+1;
            Di(k,t)=del_q; % ��¼alpha-agents����i���������˻��ľ���
            x=del_q;  
            if del_q<r %%�������˻�֮��ľ���С��ͨ�ž���
                fai=-K*(x-d)*(x-r)*(pos(i,:)-pos(j,:))/x*(d+r-x);%%���ܺ���
                u1=u1+fai;%%ʽ3.20��һ��
                sij=(pos(i,:)-pos(j,:))/x+0*(x==0);%��1��i��j֮��ĵ�λ������������2��0*��x==0��������xͬά��������󣬷�ֹx=0ʱ�����޽�
                pij=V(i,:)-sij*sij'*V(i,:)+sij*sij'*Vg;     %%ʽ3.17�� alpha-agnts������beta���¶�����ٶ�
                u2=u2+(V(i,:)-pij);    %%ʽ3.20�ڶ����������ĵڶ�������෴
            end
        end
%% ����beta-agents         
        for m=1:M %%�ϰ���
            D_io=norm(pos(i,:)-Obs(m,:));%%��i�����˻��͵�ǰ�ϰ���mԲ�ĵľ���
            kk=kk+1;
            D_O(kk,t)=D_io-Obsr(m);%%��i�����˻�����ǰ�ϰ���m��Ե�ľ���
            if D_io<=(Obsr(m)+r)%%���˻��;��ϰ���Բ�ľ���С��ͨ�ž���ʱ
                c=pos(i,:)+(Obs(m,:)-pos(i,:))*(D_io-Obsr(m))/D_io;%%�ϰ����Ե��λ������
                del_q_ib=norm(pos(i,:)-c);%%�˴���ʾ���˻��͵�ǰ�ϰ���m��Ե�ľ���
                y=del_q_ib;%%���˻��͵�ǰ�ϰ���m��Ե�ľ���
                fai=-K*2*(y-d)*(y-r)*(pos(i,:)-c)/y*(d+r-y);%%���ܺ���
                u1=u1+fai;%%ʽ3.20��һ��
                sij=(pos(i,:)-c)/del_q_ib+0*(del_q_ib==0);%��λ����
                pij=V(i,:)-sij*sij'*V(i,:)+sij*sij'*Vg;
                u2=u2+(V(i,:)-pij);%%ʽ3.20�ڶ���
            end
        end
%% ����sigmma-agents        
        ubeta=-c1b*u1-c2b*u2;%%ʽ3.20
        del_q_ig=pos(i,:)-posg;%%��ǰ���˻�i�������캽�ߵľ���֮�������
        ugamma=-c2g*10*(V(i,:)-Vg)-c1g*del_q_ig*(norm(del_q_ig));%%ʽ3.24
        u(i,:,t)=ubeta+ugamma;%%ʽ3.19
        du(i,t)=norm(u(i,:,t));%%��tʱ�̣����˻�i�Ŀ����������ٶȣ��Ĵ�С
%                 if du(i,t)>100
%                     u(i,1:3,t)=10*u(i,1:3,t)/du(i,t);
%                 end
        V(i,:)=V(i,:)+u(i,:,t)*dt;%%ʽ3.8
        pos(i,:)=pos(i,:)+V(i,:)*dt;%%ʽ3.8
        
        xx(i,t)=pos(i,1);%%��tʱ�̣����˻�i��x��λ��
        yy(i,t)=pos(i,3);%%��tʱ�̣����˻�i��z���λ�ã�������yy����Ϊplot3��ͼ˳��
        zz(i,t)=pos(i,2);%%��tʱ�̣����˻�i��y���λ��
        v(i,t)=norm(V(i,:));%%��tʱ�̣����˻�i�ٶȴ�С
    end
    
%% ��¼�������ݺ͸���leader��position    
    D_Om(t)=min(D_O(:,t));%%��tʱ�̣��������˻����ϰ����Ե���Ƿ��ײ�ϣ��ľ�������С���Ǹ�����
    DD(t)=min(Di(:,t));%aplha agents ֮����̾���
    
    %Leader �˶�------��������
    posg=posg+Vg*dt;
    xg(t)=posg(1);
    yg(t)=posg(2);
    zg(t)=posg(3);
    
    
    %----��ͼ����
        % if rem(t,10)==0%%Ϊ��ʹ��ͼ������Щ������ÿ��t����ͼ
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
        % end%%Ϊ���û�ͼ�������
        
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