% Chaotic masking DEMO from KiWi BiRD 
% https://www.youtube.com/watch?v=aNLM2ypPF_w
% Contact:kevinwang0723@gmail.com



% assign following parameter in function "chas"
alpha  = 15.6;
beta   = 28; 
m0     = -1.143;
m1     = -0.714;
L=24000;
 
x_1dot=zeros(L,1);
x_2dot=zeros(L,1);
x_3dot=zeros(L,1);
x_1=zeros(L,1);
x_2=zeros(L,1);
x_3=zeros(L,1);

%setting inital condition
x1dot(1)=0.1;
x2dot(1)=0.2;
x3dot(1)=0.3;
x1(1)=0.1;
x2(1)=0.2;
x3(1)=0.5;

% it take 10~30sec to calculate the data (depends on computer)
for i=1:L 
    %since matlab ode45 caculation dt is not equal (alogrithm), we have to
    %calculate each interval by defineing the inital(sec1) and final(sec2)  
    sec1=(i-1)*0.1;
    sec2=i*0.1;
    %in order to reduce the calcuation, we input the each 'new' inital
    %condition into the chas function and get the output of the value (x,y,z,x',y',z') in sec2
    [t,x]=ode45(@(t,x) chas(t,x,alpha,beta,m0,m1), [sec1 sec2], [x1dot(length(x1dot)) x2dot(length(x2dot)) x3dot(length(x3dot)) x1(length(x1)) x2(length(x2)) x3(length(x3))]);
    %after calcuation we get the result of sec2, which data are record in matrix 'x'
    
    %retrieving data from 'x' matrix
    x1=x(:,4);%x
    x2=x(:,5);%y
    x3=x(:,6);%z
    x1dot=x(:,1);%dx/dt
    x2dot=x(:,2);%dy/dt
    x3dot=x(:,3);%dz/dt
    
    %the last data in x1,x2,x3,x1dot,x2dot,x3dot is the data of sec2, and
    %we will keep this data
    x_1(i)=x1(length(x1));
    x_2(i)=x2(length(x2));
    x_3(i)=x3(length(x3));
    x_1dot(i)=x1dot(length(x1dot));
    x_2dot(i)=x2dot(length(x2dot));
    x_3dot(i)=x3dot(length(x3dot));
    
    %calculating next data by the for loop agian.
end


%Recording data from microphone input

fs=8000; %recording quality 8000data per second 
nBits=24; 
nChannel=1; 
duration=3; % recording 3 sec therefore we need L=8000*3=24000 data previous
recObj=audiorecorder(fs, nBits, nChannel);
fprintf('press any button to record for %g seccond\n', duration); pause
fprintf('Recording...');
recordblocking(recObj, duration);
fprintf('Done\n');
fprintf('Press any button to play'); pause
play(recObj); % playing the sound data by microphone 
y = getaudiodata(recObj, 'double'); % get data as a double array

% Encryption sound data by adding the chaos data linearly.
for i=1:length(y)
    ynew(i)=y(i)+10*x_2(i); % you can change the paramerter 10
end

time=linspace(0,length(x_1),length(x_1)); %generating correspond x data for time
subplot(6,1,1), plot(time,x_2), title('Noise Generate From Chaos');
subplot(6,1,2), plot((1:length(y))/fs, y), title('Data Collected');
xlabel('Time (sec)'); ylabel('Amplitude'); 


subplot(6,1,3), plot((1:length(y))/fs, ynew);
xlabel('Time (sec)'); ylabel('Amplitude'), title('Data After Encryption'); 
pause(3.5)
sound(ynew,fs) %playing the sound after encryption


for i=1:length(y)
    yright(i)=ynew(i)-10*x_2(i);
end
subplot(6,1,4), plot((1:length(y))/fs, yright);
xlabel('Time (sec)'); ylabel('Amplitude'), title('Data After Correct Decryption key=0.1000'); 


% Calculating the data used for decryption with wrong key(iniatl condition)
x1dot(1)=0.100001;
x2dot(1)=0.2;
x3dot(1)=0.3;
x1(1)=0.1;
x2(1)=0.2;
x3(1)=0.5;

for i=1:L 
    sec1=(i-1)*0.1;
    sec2=i*0.1;
     
[t,x]=ode45(@(t,x) chas(t,x,alpha,beta,m0,m1), [sec1 sec2], [x1dot(length(x1dot)) x2dot(length(x2dot)) x3dot(length(x3dot)) x1(length(x1)) x2(length(x2)) x3(length(x3))]);

x1=x(:,4);%x
x2=x(:,5);%y
x3=x(:,6);%z
x1dot=x(:,1);%dx/dt
x2dot=x(:,2);%dy/dt
x3dot=x(:,3);%dz/dt
x_1(i)=x1(length(x1));
x_2(i)=x2(length(x2));
x_3(i)=x3(length(x3));
x_1dot(i)=x1dot(length(x1dot));
x_2dot(i)=x2dot(length(x2dot));
x_3dot(i)=x3dot(length(x3dot));
end 

for i=1:length(y)
    ywrong(i)=ynew(i)-10*x_2(i);
end
subplot(6,1,5), plot((1:length(y))/fs, ywrong);
xlabel('Time (sec)'); ylabel('Amplitude'), title('Data After Wrong Decryption key=0.100001'); 

sound(ywrong,fs) %playing the wrong decryption result sound 


% Calculating the data used for decryption with another wrong key(iniatl condition)
x1dot(1)=0.999999;
x2dot(1)=0.2;
x3dot(1)=0.3;
x1(1)=0.1;
x2(1)=0.2;
x3(1)=0.5;

for i=1:L 
    sec1=(i-1)*0.1;
    sec2=i*0.1;
     
[t,x]=ode45(@(t,x) chas(t,x,alpha,beta,m0,m1), [sec1 sec2], [x1dot(length(x1dot)) x2dot(length(x2dot)) x3dot(length(x3dot)) x1(length(x1)) x2(length(x2)) x3(length(x3))]);

x1=x(:,4);%x
x2=x(:,5);%y
x3=x(:,6);%z
x1dot=x(:,1);%dx/dt
x2dot=x(:,2);%dy/dt
x3dot=x(:,3);%dz/dt
x_1(i)=x1(length(x1));
x_2(i)=x2(length(x2));
x_3(i)=x3(length(x3));
x_1dot(i)=x1dot(length(x1dot));
x_2dot(i)=x2dot(length(x2dot));
x_3dot(i)=x3dot(length(x3dot));
end 

for i=1:length(y)
    ywrong(i)=ynew(i)-10*x_2(i);
end

subplot(6,1,6), plot((1:length(y))/fs, ywrong);
xlabel('Time (sec)'); ylabel('Amplitude'), title('Data After Wrong Decryption key=0.999999'); 





