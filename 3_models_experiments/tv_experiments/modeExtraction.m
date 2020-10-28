function [y,R] = extraerModoFranja(F,p,ancho)
if nargin == 2
    ancho = round(p/2);
else
    if length(ancho) ~= length(p)
        ancho = round(ancho*ones(size(p))/2);
    end
end

S=abs(F);%.^2;

% Extracción de modo por ancho constante:
mascara=zeros(size(S));
%ancho=35;
for i = 1:length(p)
    intervalo = max([1 p(i)-ancho(i)]):min([p(i)+ancho(i) size(S,1)]);
    mascara(intervalo,i)=1;
end
 R=mascara.*F;
 y=(sum(R));
end