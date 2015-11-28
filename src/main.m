%% Universidade de Brasilia
% Introducao ao Processamento de Imagens 2015/2
% Trabalho Final
% Grupo: Danillo Neves - 14/01, 
%        Lucas Santos - 14/0151010 e
%        Ricardo Kury - 14/01

% Tema 7 - Filtro Cartoon

close all;

% Obtendo o diretorio das imagens
cd ../images/;
diretorio = dir ('*.jpg');
numeroImagens = length(diretorio);

% Percorrendo o diretorio, uma imagem por vez
for num = 1:numeroImagens
    
    %% Deteccao das bordas
    % Lendo as imagens
    imagemOriginal = imread(diretorio(num).name);
    figure, imshow(imagemOriginal), title('Imagem Original');

    % Guardando a imagem original em rgb
    rgbOriginal = imagemOriginal; 
    
    % Passando a imagem original para ycbcr
    yCbCrOriginal = rgb2ycbcr(imagemOriginal);
    
    % Escalando a imagem em tons de cinza
    imagemOriginal = double(imagemOriginal/255);
    
    % Obtendo a luminância da imagem original
    yQuantizado = yCbCrOriginal(:,:,1);

    %% Filtro de mediana pra reduzir o ruido
    % O tamanho do filtro de mediana pode ser ajustado.
    filtroMediana = medfilt2(yQuantizado, [7 7], 'symmetric');
    
    % A princípio, utilizaremos o método recomendado pelo artigo. Quando todas
    % as esapas estiverem concluídas, testaremos diferentes métodos de detecção
    % de bordas e escolheremos o que tem o melhor resultado subjetivo.
    bordas = edge(filtroMediana, 'canny');
    %bordas = edge(Filtered, 'sobel');

    %% Operacoes morfologicas:
    % Dilatando as bordas
    bordasGrossas = imdilate(bordas, strel('square', 2));

    %% Filtrando as bordas:
    % Diminuindo a quantidade de bordas 
    filtroBordas = bwareaopen(bordasGrossas, 300); 
    figure, imshow(filtroBordas), title('Bordas Detectadas e Expandidas da Imagem Original');
    filtroBordas = logical(filtroBordas);
    
    %% Filtro bilateral:
    % Quantizando as cores da imagem original em rgb
    [quantizacaoCores,mapaCores] = rgb2ind(rgbOriginal,6,'nodither');
    quantizacaoCores = ind2rgb(quantizacaoCores,mapaCores);
    figure, imshow(quantizacaoCores), title('Cor Quantizada');
    
    % Passando a imagem quantizada para ycbcr
    quantizadaYCbCr = rgb2ycbcr(quantizacaoCores);
    
    % Separando as camadas da imagem quantizada em ycbcr
    yQuantizado = quantizadaYCbCr(:,:,1);
    cbQuantizado = quantizadaYCbCr(:,:,2);
    crQuantizado = quantizadaYCbCr(:,:,3);

    %% Recombinacao das imagens (cores + bordas)
    % Obtendo o tamanho da imagem com as bordas filtradas
    [linhas, colunas] = size(filtroBordas);

    for x=1:linhas
        for y=1:colunas
            if filtroBordas(x,y) == 1
                quantizacaoCores(x,y,1) = 0;
                quantizacaoCores(x,y,2) = 0;
                quantizacaoCores(x,y,3) = 0;
            end
        end
    end

    figure, imshow(quantizacaoCores), title('Resultado Recombinação');
end