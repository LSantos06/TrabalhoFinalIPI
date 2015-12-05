texture = imread('../texture/lego_block.bmp');
texture = rgb2ycbcr(texture);
texture = texture(:,:,1);
%texture = imresize(texture, size(texture)/2);
texture = texture * 2;
texSize = size(texture);
imwrite(texture, '../texture/lego_block_texture.bmp');