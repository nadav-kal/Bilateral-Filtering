clc;
clear;
close all;

Gaussian = @(x, sigma) ((1/(2*pi*sigma^2)) * e^(-(x^2) / (2*sigma^2))); % Gaussian function

image_input = double(imread("lena.png"))/255.0;
sigma_s = 4;
sigma_r = 0.4;
window_size = 7;
half_window_size = ceil(window_size/2);
[Rows, Columns] = size(image_input);

for p_x = half_window_size: Rows-half_window_size
    for p_y = half_window_size: Columns-half_window_size
        P = [p_x p_y];
        I_p = image_input(p_x, p_y);
        I_p_output = 0.0;    
        W_p = 0.0;    

        for r = 1: window_size  % run of window rows
            for c = 1: window_size % run of window columns
                q_x = p_x-half_window_size+r;
                q_y = p_y-half_window_size+c;
                Q = [q_x q_y];
                I_q = image_input(q_x, q_y);
                
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
figure();
imshow(output);
title("Filtered Image");
imwrite(output, "lena_filtered_sigma_s4_sigma_r0.2_window11.png");
