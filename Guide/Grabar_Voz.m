clear;clc;
recObj = audiorecorder(8000,16,1,1);
disp('Inicializando Micro');
recordblocking(recObj,2);
% Mas muestras en n
n=15;
MFs4=zeros(298*14,n);
Cat4=zeros(5,n);

for k=1:1:n
a=input('Presione ENTER para grabar');
disp('Hable');
recordblocking(recObj,3);
disp('Silencio');
y = getaudiodata(recObj);
MF=mfcc(y,8000);
MFs4(:,k)=MF(:);
Cat4(5,k)=1;
subplot(2,1,1);
plot(y)
hold on
subplot(2,1,2);plot(MF(:))
hold on
pause(3);
end

save Voz4.mat MFs4 Cat4