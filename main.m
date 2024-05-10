%%
clc
close all
%% Carico l'immagine
immRGB = imread("image.jpeg");

%% Modifico l'immagine affinchè abbia numero righe e colonne divisibile per 8
immRGB = dim_immagine_div_8(immRGB);
%% Converto in YCbCr
immYCbCr = rgb2ycbcr(immRGB);
%% Ridico la dimensione della crominanza
% Per i due canali di crominanza eseguo la media di 4 pixel in un unico pixel
Y = immYCbCr(:,:,1);
Cb = immYCbCr(:,:,2);
Cr = immYCbCr(:,:,3);
% ds sta per downsampling
dsfun = @(block_struct) ([block_struct.data(1,1) block_struct.data(1,1);
                        block_struct.data(1,1) block_struct.data(1,1)]);
dsCb = blockproc(Cb,[2 2],dsfun);
dsCr = blockproc(Cr,[2 2],dsfun);
%% Shift dei valori di 128
Y = Y-128;
dsCb = dsCb-128;
dsCr = dsCr-128;
%% Transformata discreta coseno
dctfun = @(block_struct) dct2(block_struct.data);
dctY = blockproc(Y, [8 8], dctfun);
dctCb = blockproc(dsCb, [8 8], dctfun);
dctCr = blockproc(dsCr, [8 8], dctfun);
%% Quantizzazione dividendo elemento per elemento per la matrice definita dallo standard
quantY = quantFun(dctY);
quantCb = quantFun(dctCb);
quantCr = quantFun(dctCr);
%% Effettuo un a scansione zig zag per ogni blocco 8x8
zgzfun = @(block_struct) zigzag(block_struct.data);
zgzY = blockproc(quantY, [8 8], zgzfun);
zgzCb = blockproc(quantCb, [8 8], zgzfun);
zgzCr = blockproc(quantCr, [8 8], zgzfun);

%% Effettuo la dpct
dpcmY = dpcm(zgzY);
dpcmCb = dpcm(zgzCb);
dpcmCr = dpcm(zgzCr);

%% Effettuato la codifica Run Length salvando il risultato in un file txt (questo codice non prevede la codifica Huffman)
saveRunLength(dpcmY, "y");
saveRunLength(dpcmCb, "Cb");
saveRunLength(dpcmCr, "Cr");

%% Decoding verso l'immagine originale



