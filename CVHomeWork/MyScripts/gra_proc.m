function output = gra_proc(source,target)

[imh, imw, nb] = size(source); 

im=im2double(source);

dTar=im2double(target);

im2var = zeros(imh, imw); 
im2var(1:imh*imw) = 1:imh*imw; 

output = zeros(imh,imw,nb);
output = double(output);



   
for color=1:nb
    
    b = zeros(1,imh*imw);
    i = zeros(1,imh*imw);
    j = zeros(1,imh*imw);
    va = zeros(1,imh*imw);
    
    sparse_count = 0;
    s = im(:,:,color);
    T = dTar(:,:,color);
    e = 0;
    for y=1:imh
        for x=1:imw
            if(s(y,x)>0 && x>1 && y>1 && x<imw && y<imh)
                if (s(y-1,x)==0 || s(y+1,x)== 0 || s(y,x-1)== 0 || s(y,x+1)== 0) ...
                        && T(y,x) > 0
                    e = e+1;
                    sparse_count = sparse_count+1;
                    i(sparse_count) = e;
                    j(sparse_count) = im2var(y,x);
                    va(sparse_count) = 1;
                    b(e) = T(y,x);
                else
                    e = e+1;
                    sparse_count = sparse_count+1;
                    center_sc = sparse_count;
                    i(sparse_count) = e;
                    j(sparse_count) = im2var(y,x);
                    va(sparse_count) = 0;                  
                    if s(y-1,x) > 0                   
                        sparse_count = sparse_count+1;
                        i(sparse_count) = e;
                        j(sparse_count) = im2var(y-1,x);
                        va(sparse_count) = -1;
                        va(center_sc) = va(center_sc)+1;
                        b(e) = b(e)+s(y,x)-s(y-1,x);
                    end
                    if s(y+1,x) > 0                     
                        sparse_count = sparse_count+1;
                        i(sparse_count) = e;
                        j(sparse_count) = im2var(y+1,x);
                        va(sparse_count) = -1;
                        va(center_sc) = va(center_sc)+1;
                        b(e) = b(e)+s(y,x)-s(y+1,x);
                    end
                    if s(y,x-1) > 0                    
                        sparse_count = sparse_count+1;
                        i(sparse_count) = e;
                        j(sparse_count) = im2var(y,x-1);
                        va(sparse_count) = -1;
                        va(center_sc) = va(center_sc)+1;
                        b(e) = b(e)+s(y,x)-s(y,x-1);
                    end
                    if s(y,x+1) > 0                    
                        sparse_count = sparse_count+1;
                        i(sparse_count) = e;
                        j(sparse_count) = im2var(y,x+1);
                        va(sparse_count) = -1;
                        va(center_sc) = va(center_sc)+1;
                        b(e) = b(e)+s(y,x)-s(y,x+1);
                    end
                end
            else if s(y,x)>0
                    e = e+1;
                    sparse_count = sparse_count+1;
                    center_sc = sparse_count;
                    i(sparse_count) = e;
                    j(sparse_count) = im2var(y,x);
                    va(sparse_count) = 0;
                    if y > 1
                        if s(y-1,x) > 0                   
                            sparse_count = sparse_count+1;
                            i(sparse_count) = e;
                            j(sparse_count) = im2var(y-1,x);
                            va(sparse_count) = -1;
                            va(center_sc) = va(center_sc)+1;
                            b(e) = b(e)+s(y,x)-s(y-1,x);
                        end
                    end
                    if y < imh
                        if s(y+1,x) > 0                     
                            sparse_count = sparse_count+1;
                            i(sparse_count) = e;
                            j(sparse_count) = im2var(y+1,x);
                            va(sparse_count) = -1;
                            va(center_sc) = va(center_sc)+1;
                            b(e) = b(e)+s(y,x)-s(y+1,x);
                        end
                    end
                    if x > 1
                        if s(y,x-1) > 0                    
                            sparse_count = sparse_count+1;
                            i(sparse_count) = e;
                            j(sparse_count) = im2var(y,x-1);
                            va(sparse_count) = -1;
                            va(center_sc) = va(center_sc)+1;
                            b(e) = b(e)+s(y,x)-s(y,x-1);
                        end
                    end
                    if x < imw
                        if s(y,x+1) > 0                    
                            sparse_count = sparse_count+1;
                            i(sparse_count) = e;
                            j(sparse_count) = im2var(y,x+1);
                            va(sparse_count) = -1;
                            va(center_sc) = va(center_sc)+1;
                            b(e) = b(e)+s(y,x)-s(y,x+1);
                        end    
                    end
                else
                    e = e+1;
                    sparse_count = sparse_count+1;
                    i(sparse_count) = e;
                    j(sparse_count) = im2var(y,x);
                    va(sparse_count) = 1;
                    b(e) = T(y,x);
                end
            end
        end
    end
   
    A = sparse(i,j,va,imh*imw,imh*imw);
    b=b(:);

    v = A\b;
    
    temp = zeros(imh,imw);
    temp = double(temp);
    temp(:)=v;
    output(:,:,color) = temp;

end
