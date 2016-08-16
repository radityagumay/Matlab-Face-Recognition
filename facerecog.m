
clear all;
close all;
noc = 10; %jumlah kelas 
nos = 10; %jumlah data
k = 1;
for i = 1:noc
    img_path=['orl_faces/',strcat('s',num2str(i)),'/'];
    img_type = '*.pgm';
    
    path2 = dir([img_path img_type]);
    nfile = max(size(path2));
    for j = 1 : 9 %training
       im(j).img = imread([img_path path2(j).name]);
           %subplot(2,3,j), imshow(im(j).img); 
           %title(sprintf('Image No # %d')); hold all;
               %Extract DTCWT Features%
                [C,S] = dtwavedec2(im(j).img,3,'antonini','qshift_c');
                % Pick out subbands.
                h1 = cwtband2(C,S,1,'h','real');
                v1 = cwtband2(C,S,1,'v','real');
                d1 = cwtband2(C,S,1,'d','real');
                %figure; cimage5([v1 d1 h1]); drawnow   % Display level 1 complex subbands in colour.
                h2 = cwtband2(C,S,2,'h','real');
                v2 = cwtband2(C,S,2,'v','real');
                d2 = cwtband2(C,S,2,'d','real');
                %figure; cimage5([v2 d2 h2]); drawnow   % Display level 1 complex subbands in colour.
                h3 = cwtband2(C,S,3,'h','real');
                v3 = cwtband2(C,S,3,'v','real');
                d3 = cwtband2(C,S,3,'d','real');
                %figure; cimage5([v3 d3 h3]); drawnow   % Display level 1 complex subbands in colour.
                
                GLCM2 = graycomatrix(h1,'Offset',[0 1]);
                stats1 = GLCM_Features1(GLCM2,0);
                GLCM2 = graycomatrix(v1,'Offset',[-1 0]);
                stats2 = GLCM_Features1(GLCM2,0);
                GLCM2 = graycomatrix(d1,'Offset',[-1 1]);
                stats3 = GLCM_Features1(GLCM2,0);
                
                GLCM2 = graycomatrix(h2,'Offset',[0 1]);
                stats4 = GLCM_Features1(GLCM2,0);
                GLCM2 = graycomatrix(v2,'Offset',[-1 0]);
                stats5 = GLCM_Features1(GLCM2,0);
                GLCM2 = graycomatrix(d2,'Offset',[-1 1]);
                stats6 = GLCM_Features1(GLCM2,0);
                
                GLCM2 = graycomatrix(h3,'Offset',[0 1]);
                stats7 = GLCM_Features1(GLCM2,0);
                GLCM2 = graycomatrix(v3,'Offset',[-1 1]);
                stats8 = GLCM_Features1(GLCM2,0);
                GLCM2 = graycomatrix(d3,'Offset',[-1 1]);
                stats9 = GLCM_Features1(GLCM2,0);
                
                f(k,1) = stats1.energ; f(k,2) = stats2.energ; f(k,3) = stats3.energ;
                f(k,4) = stats1.entro; f(k,5) = stats2.entro; f(k,6) = stats3.entro;
                f(k,7) = stats1.denth; f(k,8) = stats2.denth; f(k,9) = stats3.denth;
                f(k,10) = stats1.sosvh; f(k,11) = stats2.sosvh; f(k,12) = stats3.sosvh; 
                f(k,13) = stats1.svarh; f(k,14) = stats2.svarh; f(k,15) = stats3.svarh; 
                f(k,16) = stats1.dvarh; f(k,17) = stats2.dvarh; f(k,18) = stats3.dvarh;
                
                f(k,19) = stats4.energ; f(k,20) = stats5.energ; f(k,21) = stats6.energ;
                f(k,22) = stats4.entro; f(k,23) = stats5.entro; f(k,24) = stats6.entro;
                f(k,25) = stats4.denth; f(k,26) = stats5.denth; f(k,27) = stats6.denth;
                f(k,28) = stats4.sosvh; f(k,29) = stats5.sosvh; f(k,30) = stats6.sosvh; 
                f(k,31) = stats4.svarh; f(k,32) = stats5.svarh; f(k,33) = stats6.svarh; 
                f(k,34) = stats4.dvarh; f(k,35) = stats5.dvarh; f(k,36) = stats6.dvarh;
                
                f(k,37) = stats7.energ; f(k,38) = stats8.energ; f(k,39) = stats9.energ;
                f(k,40) = stats7.entro; f(k,41) = stats8.entro; f(k,42) = stats9.entro;
                f(k,43) = stats7.denth; f(k,44) = stats8.denth; f(k,45) = stats9.denth;
                f(k,46) = stats7.sosvh; f(k,47) = stats8.sosvh; f(k,48) = stats9.sosvh; 
                f(k,49) = stats7.svarh; f(k,50) = stats8.svarh; f(k,51) = stats9.svarh; 
                f(k,52) = stats7.dvarh; f(k,53) = stats8.dvarh; f(k,54) = stats9.dvarh;
                
                f(k,55) = i; k = k +1;  
    end;  
end
F = f;