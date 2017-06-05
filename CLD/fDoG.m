function out = fDoG(img, etf, sigma1, sigma2, tau)

g1 = gaussVec(sigma1);
g2 = gaussVec(sigma1*1.6);
g3 = gaussVec(sigma2);

DoG = DirectionalDoG(img, etf, g1, g2, tau);
tmp = GetFlowDoG(etf, DoG, g3); 

out = round(tmp*255);

end

function DoG = DirectionalDoG(img, etf, g1, g2, tau)
[m n] = size(img);
halfw1 = size(g1,2);
halfw2 = size(g2,2)-1;
DoG = zeros(m,n);

for i=1:m
    for j=1:n
        sum1=.0; sum2=.0;
        wsum1=0.0; wsum2=0.0;
        weight1=0.0; weight2=0.0;
        
        vx = -etf(i,j,2);
        vy = etf(i,j,1);
        
        if vx==0 && vy==0
            sum1=255.0; sum2=255.0;
            DoG(i,j) = sum1 - tau*sum2;
            continue;
        end
        
        dx=i; dy=j;
        for s=-halfw2:halfw2
            x = dx+vx*s;
            y = dy+vy*s;
            if x>m || y>n || x<1 || y<1
                continue;
            end
            x = round(x); y = round(y);
            x = min(max(x, 1), m);
            y = min(max(y, 1), n); 
            val = img(x,y);
            
            sk = abs(s)+1;
            if sk>halfw1
                weight1=.0;
            else
                weight1=g1(sk);
            end
            
            sum1 = double(sum1 + val*weight1);
            wsum1 = wsum1 + weight1;
            
            weight2 = g2(sk);
            sum2 = double(sum2 + val*weight2);
            wsum2 = wsum2 + weight2;        
        end
        
        sum1 = sum1 / wsum1;
        sum2 = sum2 / wsum2;
        DoG(i,j) = sum1 - tau*sum2;
    end
end

end

function tmp = GetFlowDoG(etf, DoG, g3)
[m n] = size(DoG);
halfl = size(g3,2);
tmp = zeros(m,n);

for i=1:m
    for j=1:n
        weight=g3(1);
        val = DoG(i,j);
        sum = val*weight;
        wsum = weight;
        
        dx=i; dy=j;
        ix=i; iy=j;
        for k=1:halfl
            vx = etf(ix,iy,1);
            vy = etf(ix,iy,2);
            if vx==0 && vy==0
                break;
            end
            x=dx; y=dy;
            
            if x>m || x<1 || y>n || y<1
                break;
            end
            x = round(x); y = round(y);
            x = min(max(x, 1), m);
            y = min(max(y, 1), n);
            val = DoG(x,y);
            weight = g3(k);
            sum = sum + val*weight;
            wsum = wsum + weight;
            
            dx = dx + vx;
            dy = dy + vy;
            ix = round(dx);
            iy = round(dy);
            if dx<1 || dx>m || dy<1 || dy>n
                break;
            end
        end
        
        dx=i; dy=j;
        ix=i; iy=j;
        for k=1:halfl
            vx = -etf(ix,iy,1);
            vy = -etf(ix,iy,2);
            if and(vx==0, vy==0)
                break;
            end
            x=dx; y=dy;
            
            if x>m || x<1 || y>n || y<1
                break;
            end
            x = round(x); y = round(y);
            x = min(max(x, 0), m);
            y = min(max(y, 0), n);
            val = DoG(x,y);
            weight = g3(k);
            sum = sum + val*weight;
            wsum = wsum + weight;
            
            dx = dx + vx;
            dy = dy + vy;
            ix = round(dx);
            iy = round(dy);
            if dx<1 || dx>m || dy<1 || dy>n
                break;
            end
        end
        
        sum = sum / wsum;
        if sum>0
            tmp(i,j) = 1;
        else
            tmp(i,j) = tanh(sum) + 1;
        end
        
    end
end

end

function vec = gaussVec(sigma)
i = 0;
threshold = .001;
while(1)
    i = i + 1;
    if(gauss(double(i), sigma) < threshold)
        break    
    end
end

vec = zeros(1, i+1);
vec(1) = gauss(.0, sigma);
for j=2:size(vec,2)
    vec(j) = gauss(double(j-1), sigma);
end
end

function g = gauss(x,sigma)
PI = 3.14159265358979323846;
g = (exp((-x*x) / (2*sigma*sigma)) / sqrt(PI*2.0*sigma*sigma));
end