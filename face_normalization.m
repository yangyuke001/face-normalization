imgPath = '/yyk/matlab/0/';        % 图像库路径
imgDir  = dir([imgPath '*.png']); % 遍历所有jpg格式文件
for i = 1:length(imgDir)          % 遍历结构体就可以一一处理图片了
    C = imread([imgPath imgDir(i).name]); %读取每张图片
    figure(1),imshow(C);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%几何归一化&光照归一化
    C=double(C);
    image=255*imadjust(C/255,[0.3;1],[0;1]);
    

    figure(2),imshow(image/255);
    title('Lighting compensation');%光照补偿
    [x,y] = ginput(3);    %%1 left eye, 2 right eye, 3 top of nose


    cos = (x(2)-x(1))/sqrt((x(2)-x(1))^2+(y(2)-y(1))^2);
    sin = (y(2)-y(1))/sqrt((x(2)-x(1))^2+(y(2)-y(1))^2);
    mid_x = round((x(1)+x(2))/2);
    mid_y = round((y(2)+y(1))/2);
    d = round(sqrt((x(2)-x(1))^2+(y(2)-y(1))^2));
    
    rotation = atan(sin./cos)*180/pi;
    img = imrotate(image,rotation,'bilinear','crop'); 
    figure(3), imshow(img);%人脸校正

    [h,w] = size(img);
    leftpad = mid_x-d;
    if leftpad<1
        leftpad = 1;
    end
    toppad =mid_y - round(0.5*d);
    if toppad<1
        toppad = 1;
    end
    rightpad = mid_x + d;
    if rightpad>w
        rightpad = w;
    end
    bottompad = mid_y + round(1.5*d);
    if bottompad>h
        bottompad = h;
    end   
    I1 =[];
    I2 =[];
    I1(:,:) = img(toppad:bottompad,leftpad:rightpad);
    I2(:,:) = imresize(I1,[224 224]); 
    imshow(I2,[]);%人脸裁剪
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%几何归一化&光照归一化

    imwrite(I2,['/yyk/matlab/0_0/',num2str(i),'.png']);


end
