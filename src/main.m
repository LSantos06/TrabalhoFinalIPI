%% Edges
close all;
RGBoriginal =imread('dolphin-01.jpg');
figure; imshow(RGBoriginal);
title('Imagem Original');

rgb = RGBoriginal; 

YCbCroriginal = rgb2ycbcr(RGBoriginal);
RGBoriginal = double(imread('dolphin-01.jpg')/255);
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
EdgeFilter = bwareaopen(ThickEdges, 300); % Diminui a quantidade de bordas %
figure; imshow(EdgeFilter);
EdgeFilter = logical(EdgeFilter);
title('Bordas Detectadas e Expandidas da Imagem Original');

%% Bilateral Filter(Color):
[ColorQuantization,colormap] = rgb2ind(rgb,6,'nodither');
ColorQuantization = ind2rgb(ColorQuantization,colormap);
figure, imshow(ColorQuantization);
title('Cor Quantizada');

Color_YCBCR = rgb2ycbcr(ColorQuantization);
Y_Original = Color_YCBCR(:,:,1);
CB_Original = Color_YCBCR(:,:,2);
CR_Original = Color_YCBCR(:,:,3);

%% Recombine(Overlay Edge Imagem with Color Image)
[linhas colunas] = size(EdgeFilter);

for x=1:linhas
    for y=1:colunas
        if EdgeFilter(x,y) == 1
            ColorQuantization(x,y,1) = 0;
            ColorQuantization(x,y,2) = 0;
            ColorQuantization(x,y,3) = 0;
        end
    end
end

figure, imshow(ColorQuantization);
title('Resultado Recombinação');