%% Universidade de Brasilia
% Introducao ao Processamento de Imagens 2015/2
% Trabalho Final
% Grupo: Danillo Neves - 14/0135839
%        Lucas Santos - 14/0151010 e
%        Ricardo Kury - 14/0161082

% Filtro LEGO

close all;

% Lendo e obtendo o tamanho da imagem que representa a textura do LEGO
texturaLEGO = imread('../texture/lego_block_texture.bmp');
tamanhoTexturaLEGO = size(texturaLEGO);

% Obtendo o diretorio das imagens
cd ../images/;
diretorio = dir ('*.jpg');
numeroImagens = length(diretorio);

% Percorrendo o diretorio, uma imagem por vez
for num = 1:1

    %% Leitura e tamanhos
    % Lendo e obtendo o tamanho da imagem a ser texturizada
    imagemOriginal = imread('../images/brasilia.jpg');
    %imagemOriginal = imread(diretorio(num).name);
    tamanhoImagemOriginal = size(imagemOriginal);
    
    % Ajustando o tamanho da textura ao tamanho da imagem a ser texturizada
    tamanhoImagemOriginal(1:2) = tamanhoImagemOriginal(1:2)+(tamanhoTexturaLEGO-mod(tamanhoImagemOriginal(1:2), tamanhoTexturaLEGO));
    imagemOriginal = imresize(imagemOriginal, tamanhoImagemOriginal(1:2));

    % Ajustando o tamanho das cores 
    cor = imresize(imagemOriginal, tamanhoImagemOriginal(1:2)./tamanhoTexturaLEGO);
    tamanhoCor = size(cor);

    % Calculando o tamanho da imagem final
    tamanhoFinal = imresize(cor, tamanhoImagemOriginal(1:2), 'nearest');
    tamanhoFinal = im2double(tamanhoFinal);
    
    % Alocando a imagem resultado 
    imagemResultado = zeros(tamanhoImagemOriginal);
    
    %% LEGO
    for i = 1:tamanhoImagemOriginal(1)
        restoLinhas = mod(i-1, tamanhoTexturaLEGO(1)) + 1;
        for j = 1:tamanhoImagemOriginal(2)
            restoColunas = mod(j-1, tamanhoTexturaLEGO(2)) + 1;
            for k = 1:tamanhoImagemOriginal(3)
                imagemResultado(i,j,k) = tamanhoFinal(i,j,k)*texturaLEGO(restoLinhas,restoColunas);
            end
        end
    end
    
    %% Plots
    figure, set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    subplot(1,2,1), imshow(imagemOriginal), title('Original');
    subplot(1,2,2), imshow(uint8(imagemResultado)), title('LEGOlized');
    
    nome = sprintf('../results/LEGO/LEGOlized_%d.png', num);
    imwrite(uint8(imagemResultado), nome);
    
end % for %