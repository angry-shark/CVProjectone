I1 = imread('../Test2_1.jpg');
I2 = imread('../Test2_2.jpg');

I1 = imresize(I1,1,'nearest');
I2 = imresize(I2,1,'nearest');


H = [1 0 400; 0 1 100; 0 0 1];
tform = maketform('projective',H');
Base = imtransform(I2,tform,'nearest','xyscale',1,...
                'xdata', [1 2000], 'ydata', [1 1000],...
                'fillvalues', 0);

tform = auto(I1,Base);
Base_tmp = imtransform(I1,tform,'nearest','xyscale',1,...
                'xdata', [1 2000], 'ydata', [1 1000],...
                'fillvalues', 0);
            
Base = gra_proc(Base_tmp,Base);
figure;
imshow(Base);