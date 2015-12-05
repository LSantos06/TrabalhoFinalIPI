close all

texture = imread('../texture/lego_block_texture.bmp');
texSize = size(texture);

image = imread('../images/van-gogh.jpg');
imgSize = size(image);
imgSize(1:2) = imgSize(1:2)+(texSize-mod(imgSize(1:2), texSize));
image = imresize(image, imgSize(1:2));


%%
colorModel = imresize(image, imgSize(1:2)./texSize);
cmSize = size(colorModel);

%%
upscaled = imresize(colorModel, imgSize(1:2), 'nearest');
upscaled = im2double(upscaled);
result = zeros(imgSize);
for i = 1:imgSize(1)
    rest1 = mod(i-1, texSize(1)) + 1;
    for j = 1:imgSize(2)
        rest2 = mod(j-1, texSize(2)) + 1;
        for k = 1:imgSize(3)
            result(i,j,k) = upscaled(i,j,k)*texture(rest1,rest2);
        end
    end
end
imshow(uint8(result));
imwrite(uint8(result),'legolized.png');