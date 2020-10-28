function zita = twoPointRandomWalk(N)
if nargin == 0
    N = 1;
end

zita = round(rand(1,N));
zita(zita==0) = -1;

end