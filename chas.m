function xdot=chas(t,x,alpha,beta,m0,m1)
% specific parameter used in chua's circuit
% alpha  = 15.6;
% beta   = 28; 
% m0     = -1.143;
% m1     = -0.714;
% nolinear respond of chua's circuit's resistor
h = m1*x(1)+0.5*(m0-m1)*(abs(x(1)+1)-abs(x(1)-1));
% chua's differntial equation from wiki
% xdot(1) =dx/dt ; xdot(2)=dy/dt ; xdot(3)=dz/dt
xdot(1) = alpha*(x(2)-x(1)-h);
xdot(2) = x(1) - x(2)+ x(3);
xdot(3) = -beta*x(2);
xdot(4)=x(1);
xdot(5)=x(2);
xdot(6)=x(3);

xdot=xdot';