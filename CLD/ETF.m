function etf = ETF(img, halfw, smoothPasses)
[m n] = size(img);
% (tx, ty, mag)
etf = etf_init(img);
Gx = etf(:,:,1);
Gy = etf(:,:,2);
mag = etf(:,:,3);

% % initial
% [Gx Gy] = imgradientxy(img);
% % taking perpendicular vectors(in the counter-clockwise sense)
% tmp = Gx;
% Gx = -Gy;
% Gy = tmp;
% mag = sqrt(Gx.*Gx + Gy.*Gy);
% 
% % normalize
% max_grad = max(mag(:));
% mag = mag/max_grad*255;
% Gx = Gx./mag;
% Gy = Gy./mag;
% 
% % handle divide by zero
% Gx(isnan(Gx)) = 0;
% Gy(isnan(Gy)) = 0;

% load('tx.mat');
% load('ty.mat');
% load('tmag.mat');
% Gx = tx;
% Gy = ty;
% mag = tmag;
% etf(:,:,3) = mag;

% smooth _ halfw, smoothPasses
for iter=1:smoothPasses
    for j=1:n
        for i=1:m
            %% ----------------------- horizontal
            % tx, ty is t_new(x)
            tx = 0; ty = 0;
            % cx, cy is t_cur(x)
            cx = Gx(i,j); cy = Gy(i,j);
            
            % iterate for neighborhood of x in horizontal
            for k=-halfw:halfw
                % control outside of border
                % vx, vy is t_cur(y)
                if i+k>m
                    x = m; y = j;
                elseif i+k<1
                    x = 1; y = j;
                else
                    x = i+k; y = j;
                end
                vx = Gx(x,y); vy = Gy(x,y);
                
                % spatial is w_s(x,y), eq(2)
                % note that, w_s is always 1. use radially-symmetrix box
                
                % use paper's equation, instead of refer the impl code
                
                % weight_mag is w_m(x,y), eq(3)
                mag_diff = tanh(mag(x,y) - mag(i,j));
                weight_mag = (mag_diff + 1) * 0.5;
%                 mag_diff = mag(x,y) - mag(i,j);
%                 weight_mag = mag_diff + 1;
                
                % weight_dir is w_d(x,y), eq(4)
                weight_dir = abs(cx*vx+cy*vy);
%                 weight_dir = 1;
                
                % factor is phi(x,y), eq(5)
                factor = 1;
                if cx*vx+cy*vy<0
                    factor = -1;
                end
                
                tx = tx + factor*vx*weight_mag*weight_dir;
                ty = ty + factor*vy*weight_mag*weight_dir;
            end
            
            % normalize
            tmp = sqrt(tx*tx+ty*ty);
            if tmp ~= 0
                tx = tx / tmp;
                ty = ty / tmp;
            else
                tx = 0;
                ty = 0;
            end
            
            etf(i, j, 1) = tx;
            etf(i, j, 2) = ty;
        end
    end
    
    Gx = etf(:,:,1);
    Gy = etf(:,:,2);
    
    for j=1:n
        for i=1:m
            %% -----------------------vertical
            % tx, ty is t_new(x)
            tx = 0; ty = 0;
            % cx, cy is t_cur(x)
            cx = Gx(i,j); cy = Gy(i,j);
            
            % iterate for neighborhood of x in horizontal
            for k=-halfw:halfw
                % control outside of border
                % vx, vy is t_cur(y)
                if j+k>n
                    x = i; y = n;
                elseif j+k<1
                    x = i; y = 1;
                else
                    x = i; y = j+k;
                end
                vx = Gx(x,y); vy = Gy(x,y);
                
                % spatial is w_s(x,y), eq(2)
                % note that, w_s is always 1. use radially-symmetrix box
                
                % weight_mag is w_m(x,y), eq(3)
                mag_diff = tanh(mag(x,y) - mag(i,j));
                weight_mag = (mag_diff + 1) * 0.5;
%                 mag_diff = mag(x,y) - mag(i,j);
%                 weight_mag = mag_diff + 1;
                
                % weight_dir is w_d(x,y), eq(4)
                weight_dir = abs(cx*vx+cy*vy);
%                 weight_dir = 1;
                
                % factor is phi(x,y), eq(5)
                factor = 1;
                if cx*vx+cy*vy<0
                    factor = -1;
                end
                
                tx = tx + factor*vx*weight_mag*weight_dir;
                ty = ty + factor*vy*weight_mag*weight_dir;
            end
            
            % normalize
            tmp = sqrt(tx*tx+ty*ty);
            if tmp ~= 0
                tx = tx / tmp;
                ty = ty / tmp;
            else
                tx = 0;
                ty = 0;
            end
            
            etf(i, j, 1) = tx;
            etf(i, j, 2) = ty;
        end
    end
    
    Gx = etf(:,:,1);
    Gy = etf(:,:,2);
end
end