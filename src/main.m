%% Edges

RGBoriginal = imread('../images/lamborghini-rainbow.jpg');
YCbCroriginal = rgb2ycbcr(RGBoriginal);
Yoriginal = YCbCroriginal(:,:,1);
% All edge processing tasks are performed with a single-channel grayscale 
% image derived from the luminance values of the input.

%% Median Filter (reduce salt and pepper noise):
%O tamanho do filtro de mediana pode ser ajustado.
Filtered = medfilt2(Yoriginal, [7 7], 'symmetric');
%A princ�pio, utilizaremos o m�todo recomendado pelo artigo. Quando todas
%as esapas estiverem conclu�das, testaremos diferentes m�todos de detec��o
%de bordas e escolheremos o que tem o melhor resultado subjetivo.
Edges = edge(Filtered, 'canny');
%Edges = edge(Filtered, 'sobel');

%% Morphological operations:
ThickEdges = imdilate(Edges, strel('square', 2));

%% Edge filter:
%TODO