function [k_mask1]=get_stitch_mask(img1, img2)
% �ֱ𷵻�ͼƬ1��ͼƬ2��ͬ���ֵ�mask
% ����������ͼƬ��ͼƬ�������Լ��Ĳ���ΪNaN

mask_12=((~isnan(img1)).*(~isnan(img2))); %img1 img2��ͬ����
mask_1n2 = ((~isnan(img1)).*(isnan(img2))); %��img1 ��img2�Ĳ���
mask_n12 = ((isnan(img1)).*(~isnan(img2))); %��img1 ��img2�Ĳ���

f_average=fspecial('average',[5,5]);%3*3��ֵ�˲�

mask_1n2_ave=imfilter(mask_1n2,f_average);
edge1 = (mask_1n2_ave>0).*(mask_12);
%imshow(edge1);

mask_n12_ave=imfilter(mask_n12,f_average);
edge2 = (mask_n12_ave>0).*(mask_12);
%imshow(edge2);

%��ȡ1��2�ı߽������
edge1_points = [];
edge2_points = [];
for i=1:size(edge1,1)
    for j=1:size(edge1,2)
        if edge1(i,j)==1
            edge1_points(size(edge1_points,1)+1, :) = [j i];
            break;
        end
    end
end
for i=1:size(edge2,1)
    for j=1:size(edge2,2)
        if edge2(i,j)==1
            edge2_points(size(edge2_points,1)+1, :) = [j i];
            break;
        end
    end
end

%��y������һ�����Բ�ֵ
k_mask1=mask_1n2;
edge2_max_j=max(edge2_points(:,1));
for i = 1:size(edge1_points,1)
    p = edge1_points(i, :);
    for imgj = p(1):edge2_max_j
        if mask_n12(p(2), imgj)==1
            break;
        end
    end
    j_end=imgj;
    diff_pix = 1:-1/(j_end-p(1)):0;
    k_mask1(p(2), p(1):j_end)=diff_pix;
end

k_mask1=imfilter(k_mask1,f_average);
k_mask1(mask_12<1)=0;
k_mask2 = 1-k_mask1;
k_mask1 = k_mask1+mask_1n2;
k_mask2 = k_mask2+mask_n12;

%imshow(k_mask1+mask_1n2);

% num_sample=60;
% edge1_points=edge1_points(1:round(size(edge1_points,1)/num_sample):end,:);
% edge2_points=edge2_points(1:round(size(edge2_points,1)/num_sample):end,:);
% 
% imshow(edge2);hold on;
% plot( edge1_points(:,1),edge1_points(:,2),'r.' );
% plot( edge2_points(:,1),edge2_points(:,2),'g.' );
% 
% p_y=[ones(size(edge1_points,1),1);zeros(size(edge2_points,1),1)];
% result_img = thin_plate_1dim( edge2, [edge1_points; edge2_points], p_y);
% re_result_img = uint8(round(255*result_img/max(max(result_img))));
% imshow(re_result_img);

end