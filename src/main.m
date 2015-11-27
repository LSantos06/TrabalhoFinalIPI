%% Edges

RGBoriginal = imread('../images/lamborghini-rainbow.jpg');
YCbCroriginal = rgb2ycbcr(RGBoriginal);
Yoriginal = YCbCroriginal(:,:,1);
% All edge processing tasks are performed with a single-channel grayscale 
% image derived from the luminance values of the input.

%% Median Filter (reduce salt and pepper noise):
%O tamanho do filtro de mediana pode ser ajustado.
Filtered = medfilt2(Yoriginal, [7 7], 'symmetric');
%A princípio, utilizaremos o método recomendado pelo artigo. Quando todas
%as esapas estiverem concluídas, testaremos diferentes métodos de detecção
%de bordas e escolheremos o que tem o melhor resultado subjetivo.
Edges = edge(Filtered, 'canny');
%Edges = edge(Filtered, 'sobel');

%% Morphological operations:
ThickEdges = imdilate(Edges, strel('square', 2));

%% Edge filter:
%Segundo o artigo, o valor mínimo de 10 na hora do  produz os resultados mais satisfatórios
EdgeFilter = bwareaopen(ThickEdges, 10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TÁ ERRADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bilateral Filter(Color):
[linhas, colunas] = size(CRoriginal); 
CR_Menor = imresize(CRoriginal, [linhas/4 colunas/4]); % Diminuindo tamanho da imagem para diminuir peso do processamento
Bilateral_Filter = fspecial('gaussian', [9 9]);
for aux=1: 14
    CR_Menor = imfilter(CR_Menor, Bilateral_Filter);% Aplicando Bilateral Filtering com Máscara 9x9 por 14 vezes
end
CR_Maior = imresize(CR_Menor, [linhas colunas]); % Colocando imagem para o tamanho original

%% Median Filter(Reduce noise after resizing):
Median_Filter = medfilt2(CR_Maior, [7 7], 'symmetric');

%% Quantize Colors:
%reducao_cor = 24;
%funcao = @(x) (x/24)*24;
%funcao = (pixel/reducao_cor)*reducao_cor;
%Quantize = arrayfun(funcao, Median_Filter);

thresh = multithresh(Median_Filter,20);
value = [0 thresh(2:end) 255];
quant = imquantize(Median_Filter, thresh, value);

%% Recombine

overlay_im = cat(3, EdgeFilter, Cboriginal, quant);
overlay_im = rgb2ycbcr(overlay_im);
imshow(overlay_im);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TÁ ERRADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TODO
