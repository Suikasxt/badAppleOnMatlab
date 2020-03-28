clear;
clc;
obj = VideoReader('badapple.mp4');
num = obj.NumFrames;
for F = 1:num
    frame = read(obj, F);
    frame = im2bw(frame);
    pic = bwperim(frame);
    [H,W]=size(pic);
    for x = 1:W
        pic(46, x) = 1 - pic(46, x);
        pic(315, x) = 1 - pic(315, x);
    end
    
    for x = 1:H
        pic(x, 1) = 0;
        pic(x, W) = 0;
    end
    
    %imshow(pic);
    
    [X, Y] = findOutline(pic);
    
    temp = Y;
    Y = -X;
    X = temp;
    
    plot(X, Y);
    axis([0 W -H 0]);
    pause(0.03);
end

function [resultX, resultY]=findOutline(pic)
    [H, W] = size(pic);
    X = -1;
    for x = 1:H
        flag  = 0;
        for y = 1:W
            if pic(x, y)==1
                X = x;
                Y = y;
                flag = 1;
                break
            end
        end
        if flag == 1
            break
        end
    end
    pic(X, Y) = 0;
    if (X > -1)
        [X, Y, pic] = Walk(pic, X, Y, 1);
        [X, Y, pic] = Walk(pic, X, Y, 0);
    end
    resultX = X;
    resultY = Y;
end
function [resultX, resultY, resultPic] = Walk(pic, X, Y, dir)
    [H, W] = size(pic);
    if dir == 1
        nx = X(length(X));
        ny = Y(length(Y));
    else
        nx = X(1);
        ny = Y(1);
    end
        
    Dis = 30;
    resultX = X;
    resultY = Y;
    while 1
        flag2 = 0;
        for dis = 1:Dis
            flag = 0;
            for dx = -dis:dis
                dy = dis - abs(dx);
                if ny+dy<=W && nx+dx<=H && pic(nx+dx, ny+dy)==1
                    nx = nx+dx;
                    ny = ny+dy;
                    if dir == 1
                        resultX = [resultX nx];
                        resultY = [resultY ny];
                    else
                        resultX = [nx resultX];
                        resultY = [ny resultY];
                    end
                    pic(nx, ny) = 0;
                    flag = 1;
                    flag2 = 1;
                    break;
                end
                if ny-dy>=1 && nx+dx<=H && pic(nx+dx, ny-dy)==1
                    nx = nx+dx;
                    ny = ny-dy;
                    if dir == 1
                        resultX = [resultX nx];
                        resultY = [resultY ny];
                    else
                        resultX = [nx resultX];
                        resultY = [ny resultY];
                    end
                    pic(nx, ny) = 0;
                    flag = 1;
                    flag2 = 1;
                    break;
                end
            end
            
            if flag == 1
                break
            end
        end
        
        if flag2 == 0
            break
        end
    end
    resultPic = pic;
    %imshow(pic);
end
