% Data una matrice per ogni blocco 8x8 il valore del primo elemento è
% sottratto con qullo del blocco precedente, a eccezione del primo blocco.
function mtrx = dpcm(mtrx)
    [M, N] = size(mtrx);
    sottraendo = mtrx(1, 1);
    for i = 1:M
        for j=1:64:N
            if i ~= 1 && j ~= 1
                sottraendo_tmp = mtrx(i, j);
                mtrx(i, j) = mtrx(i, j) - sottraendo;
                sottraendo = sottraendo_tmp;
            end
        end
    end
end