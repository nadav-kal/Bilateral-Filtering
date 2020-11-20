clc;
clear;
close all;

Gaussian = @(x, sigma) ((1/(2*pi*sigma^2)) * e^(-(x^2) / (2*sigma^2))); % Gaussian function

image_input = double(imread("image--159.jpg"))/255.0;
sigma_s = 4;
sigma_r = 0.2;
% image_output = zeros(size(image_input));
window_size = 7;
half_window_size = ceil(window_size/2);

if size(image_input,3)==3   % input is a colored image
    image_input = rgb2ycbcr(image_input);
    image_input_gray = image_input(:, :, 1); % take the gray color image
    [Rows, Columns, number_of_color_channels] = size(image_input);
else
    image_input_gray = image_input;
    [Rows, Columns] = size(image_input);
end

for p_x = half_window_size: Rows-half_window_size
    for p_y = half_window_size: Columns-half_window_size
        P = [p_x p_y];
        I_p = image_input_gray(p_x, p_y);
        I_p_output = 0.0;    
        W_p = 0.0;    

        for r = 1: window_size  % run of window rows
            for c = 1: window_size % run of window columns
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
if size(image_input,3)==3   % input is a colored image
    output(:,:,2)= image_input(half_window_size:Rows-half_window_size,half_window_size:Columns-half_window_size,2);
    output(:,:,3)= image_input(half_window_size:Rows-half_window_size,half_window_size:Columns-half_window_size,3);
end

imshow(output);
imwrite(output, "image--159_filtered.jpg");
