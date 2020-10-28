function [P]= ridgeDetection(F,I,alfa,beta,K,fmax)
% Ridge detection.

S=abs(F).^2; % Espectrograma.
N=size(S,2);
M=size(S,1);

if nargin<2
    I=30; % Valor por defecto.
end

if nargin < 5
    k = zeros(size(F,1),1);
else
    k=(1:K*fmax)';
end

margin = round(N/10);
P=zeros(1,N);
c=zeros(1,N);

REPS = 30;
P=zeros(REPS,N);
C = zeros(REPS,1);

for j=1:REPS
    % Inicialización
    p=zeros(1,N); % Vector de posiciones.
    c=zeros(1,N); % Vector de maximos.
    c0=randi([margin,N-margin]); % Elijo un indice inicial.
    [c(c0),p(c0)]=max(S(:,c0).^2);
    [c(c0-1),p(c0-1)]=max(S(:,c0-1)-alfa*(k-p(c0)).^2);
    
    % Desde c0 hacia adelante
    for i=c0+1:N
        %interval = (p(i-1)-I:p(i-1)+I)';
        interval = (max([p(i-1)-I 1]):min([p(i-1)+I M]))';
        [c(i),p(i)]=max(S(interval,i) - alfa*(interval-p(i-1)).^2 ...
            - beta*(interval-2*p(i-1)+p(i-2)).^2);
        p(i)=p(i)+interval(1)-1;
        %disp(p(i));
    end
    
    % Desde c0 hacia atrás
    for i=c0-1:-1:2
        interval = (max([p(i)-I 1]):min([p(i)+I M]))';
        [c(i-1),p(i-1)]=max(S(interval,i) - alfa*(interval-p(i)).^2 ...
            - beta*(interval-2*p(i)+p(i+1)).^2);
        p(i-1)=p(i-1)+interval(1)-1;
        %disp(p(i-1));
    end
    
    P(j,:) = p;
    C(j) = sum(c);
end

[~,ind] = max(C);
P=P(ind(1),:);

end