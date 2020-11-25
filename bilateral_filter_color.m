clc;
clear;
close all;

Gaussian = @(x, sigma) ((1/(2*pi*sigma^2)) * e^(-(x^2) / (2*sigma^2))); % Gaussian function

image_input = imread("river.png");
sigma_s = 10;
sigma_r = 0.1;
window_size = 5;
half_window_size = ceil(window_size/2);

image_input = rgb2ycbcr(image_input);
image_input_gray = (double(image_input(:, :, 1)))/255.0; % take the gray color image
[Rows, Columns, number_of_color_channels] = size(image_input);

for p_x = half_window_size: Rows-half_window_size
    for p_y = half_window_size: Columns-half_window_size
        P = [p_x p_y];
        I_p = image_input_gray(p_x, p_y);
        I_p_output = 0.0;    
        W_p = 0.0;    

        for r = 1: window_size
            for c = 1: window_size
                q_x = p_x-half_window_size+r;
                q_y = p_y-half_window_size+c;
                Q = [q_x q_y];
                I_q = image_input_gray(q_x, q_y);
                
                w = Gaussian(norm(P-Q),sigma_s) * Gaussian(I_p-I_q, sigma_r);
                I_p_output = I_p_output + w * I_q;
                W_p = W_p + w;

            end
        end
        I_p_output = I_p_output / W_p;
        image_output(p_x-half_window_size+1, p_y-half_window_size+1) = I_p_output;

    end
end

output = uint8(image_output*255.0);
output(:,:,2)= image_input(half_window_size:Rows-half_window_size,half_window_size:Columns-half_window_size,2);
output(:,:,3)= image_input(half_window_size:Rows-half_window_size,half_window_size:Columns-half_window_size,3);
output = ycbcr2rgb(output);

imshow(output);
parameters = sprintf("sigma_s = %d sigma_r = %d window = %d", sigma_s, sigma_r, window_size);
title(parameters)
imwrite(output, "river_filtered.png");
