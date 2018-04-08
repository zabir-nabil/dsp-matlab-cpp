function [ out_image ] = modifiedMedianFiltering( in_image, tmin, tmax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[row,col,band]=size(in_image);

out_image(:,:,1)=in_image(:,:,1);

for i=1:band
    for j=2:row-1
        for k=2:col-1
            if in_image(j,k,i)~=tmin && in_image(j,k,i)~=tmax
                continue;
            end
            cnt=0;
            for l=j-1:j+1
                for m=k-1:k+1
                    if in_image(l,m,i)==tmin || in_image(l,m,i)==tmax
                        cnt=cnt+1;
                    end
                end
            end
            if cnt<=4 || j-1==1 || k-1==1 || j+1==row || k+1==col
                ara=[];
                id=1;
                for l=j-1:j+1
                    for m=k-1:k+1
                        ara(id)=in_image(l,m,i);
                        id=id+1;
                    end
                end
                ara=sort(ara);
                out_image(j,k,i)=ara(5);
            else
                cnt=0;
                for l=j-2:j+2
                    for m=k-2:k+2
                        if in_image(l,m,i)==tmin || in_image(l,m,i)==tmax
                            cnt=cnt+1;
                        end
                    end
                end
                if cnt<=12 || j-2==1 || k-2==1 || j+2==row || k+2==col
                    ara=[];
                    id=1;
                    for l=j-2:j+2
                        for m=k-2:k+2
                            ara(id)=in_image(l,m,i);
                            id=id+1;
                        end
                    end
                    ara=sort(ara);
                    out_image(j,k,i)=ara(13);
                else
                    cnt=0;
                    for l=j-3:j+3
                        for m=k-3:k+3
                            if in_image(l,m,i)==tmin || in_image(l,m,i)==tmax
                                cnt=cnt+1;
                            end
                        end
                    end
                    ara=[];
                    id=1;
                    for l=j-3:j+3
                        for m=k-3:k+3
                            ara(id)=in_image(l,m,i);
                            id=id+1;
                        end
                    end
                    ara=sort(ara);
                    out_image(j,k,i)=ara(25);
                end
            end
        end
    end
end

% filtering side pixel

for i=1:band
    for j=2:col-1
        if in_image(1,j,i)~=tmin && in_image(1,j,i)~=tmax
            continue;
        end
        ara=[];
        id=1;
        for l=1:3
            for m=j-1:j+1
                ara(id)=in_image(l,m,i);
                id=id+1;
            end
        end
        ara=sort(ara);
        out_image(1,j,i)=ara(5);
    end
    
    for j=2:col-1
        if in_image(row,j,i)~=tmin && in_image(row,j,i)~=tmax
            continue;
        end
        ara=[];
        id=1;
        for l=row-2:row
            for m=j-1:j+1
                ara(id)=in_image(l,m,i);
                id=id+1;
            end
        end
        ara=sort(ara);
        out_image(row,j,i)=ara(5);
    end
    
    for j=2:row-1
        if in_image(j,1,i)~=tmin && in_image(j,1,i)~=tmax
            continue;
        end
        ara=[];
        id=1;
        for l=j-1:j+1
            for m=1:3
                ara(id)=in_image(l,m,i);
                id=id+1;
            end
        end
        ara=sort(ara);
        out_image(j,1,i)=ara(5);
    end
    
    for j=2:row-1
        if in_image(j,col,i)~=tmin && in_image(j,col,i)~=tmax
            continue;
        end
        ara=[];
        id=1;
        for l=j-1:j+1
            for m=col-2:col
                ara(id)=in_image(l,m,i);
                id=id+1;
            end
        end
        ara=sort(ara);
        out_image(j,col,i)=ara(5);
    end
    
    if in_image(1,1,i)==tmin || in_image(1,1,i)==tmax
        ara=[];
        id=1;
        for l=1:3
            for m=1:3
                ara(id)=in_image(l,m,i);
                id=id+1;
            end
        end
        ara=sort(ara);
        out_image(1,1,i)=ara(5);
    end
    
    if in_image(row,1,i)==tmin || in_image(row,1,i)==tmax
        ara=[];
        id=1;
        for l=row-2:row
            for m=1:3
                ara(id)=in_image(l,m,i);
                id=id+1;
            end
        end
        ara=sort(ara);
        out_image(row,1,i)=ara(5);
    end
    
    if in_image(1,col,i)==tmin || in_image(1,col,i)==tmax
        ara=[];
        id=1;
        for l=1:3
            for m=col-2:col
                ara(id)=in_image(l,m,i);
                id=id+1;
            end
        end
        ara=sort(ara);
        out_image(1,col,i)=ara(5);
    end
    
    if in_image(row,col,i)==tmin || in_image(row,col,i)==tmax
        ara=[];
        id=1;
        for l=row-2:row
            for m=col-2:col
                ara(id)=in_image(l,m,i);
                id=id+1;
            end
        end
        ara=sort(ara);
        out_image(row,col,i)=ara(5);
    end

    
    
end

